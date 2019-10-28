//
//  EditCategoryViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 14/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


protocol EditCategoryDelegate: class {
    func didFinishEditingCategories(selectionDone: Bool)
}

class EditCategoryViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var lblEditCategory: UILabel!
    @IBOutlet weak var categoryFld: UITextField!
    @IBOutlet weak var subCategoryFld: UITextField!
    @IBOutlet weak var experienceFld: UITextField!
    @IBOutlet weak var pricePerHourFld: UITextField!
    @IBOutlet weak var quickPitchFld: UITextField!
    @IBOutlet weak var closeImg: UIImageView!
    
    @IBOutlet weak var btnDelete: UIButton!
    weak var delegate : EditCategoryDelegate?
    
    var serviceDictionary : [String:JSON]!
    let ACCEPTABLE_CHARACTERS = "0123456789"
    var mycolor = UIColor()
    @IBOutlet weak var editButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryFld.delegate = self
        subCategoryFld.delegate = self
        pricePerHourFld.delegate = self
        experienceFld.delegate = self
        quickPitchFld.delegate = self
        
        print(serviceDictionary)
        categoryFld.text = serviceDictionary["category_name"]?.stringValue
        subCategoryFld.text = serviceDictionary["sub_category_name"]?.stringValue
        experienceFld.text = serviceDictionary["experience"]?.stringValue
        pricePerHourFld.text = serviceDictionary["priceperhour"]?.stringValue
        quickPitchFld.text = serviceDictionary["quickpitch"]?.stringValue
        lblEditCategory.text = "EDIT CATEGORY DETAILS".localized()
        lblEditCategory.font = FontBook.Medium.of(size: 16)
        categoryFld.font = FontBook.Regular.of(size: 15)
        subCategoryFld.font = FontBook.Regular.of(size: 15)
        experienceFld.font = FontBook.Regular.of(size: 15)
        pricePerHourFld.font = FontBook.Regular.of(size: 15)
        quickPitchFld.font = FontBook.Regular.of(size: 15)
        editButton.titleLabel?.font = FontBook.Medium.of(size: 17)
        btnDelete.titleLabel?.font = FontBook.Medium.of(size: 17)
        
        
        categoryFld.placeholder = "Category".localized()
        subCategoryFld.placeholder = "Sub Category".localized()
        experienceFld.placeholder = "Experience in Months".localized()
        pricePerHourFld.placeholder = "Price / Hr (in $)".localized()
        quickPitchFld.placeholder = "Quick Pitch".localized()
        editButton.setTitle("EDIT".localized(), for: .normal)
        btnDelete.setTitle("DELETE".localized(), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            editButton.backgroundColor = mycolor
            btnDelete.backgroundColor = mycolor
            changeTintColor(closeImg, arg: mycolor)
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        deleteCategory()
    }
    @IBAction func editAction(_ sender: UIButton) {
        if(sender.titleLabel?.text == "EDIT".localized()){
            sender.setTitle("SAVE".localized(), for: .normal)
            experienceFld.isUserInteractionEnabled = true
            pricePerHourFld.isUserInteractionEnabled = true
            quickPitchFld.isUserInteractionEnabled = true
            
            experienceFld.textColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            pricePerHourFld.textColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            quickPitchFld.textColor = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        }
        else{
            experienceFld.isUserInteractionEnabled = false
            pricePerHourFld.isUserInteractionEnabled = false
            quickPitchFld.isUserInteractionEnabled = false
            updateCategory()
            sender.setTitle("EDIT".localized(), for: .normal)
            
            experienceFld.textColor = UIColor.lightGray
            pricePerHourFld.textColor = UIColor.lightGray
            quickPitchFld.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func updateCategory(){
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
        {
            headers = [
                "Authorization": accesstoken,
                "Accept": "application/json"
            ]
        }
        else
        {
            headers = [
                "Authorization": "",
                "Accept": "application/json"
            ]
        }
        
        let pricePerHour = self.pricePerHourFld.text!
        let quickpitch = self.quickPitchFld.text!
        let experience = self.experienceFld.text!
        
        let provServiceId = self.serviceDictionary["id"]?.stringValue
        var providerid = ""
        if SharedObject().hasData(value: provServiceId)
        {
            providerid = provServiceId!
        }
        let params: Parameters = [
            "provider_service_id": providerid,
            "priceperhour":pricePerHour,
            "quickpitch":quickpitch,
            "experience":experience
        ]
        SwiftSpinner.show("Updating service...".localized())
        let url = APIList().getUrlString(url: .EDIT_CATEGORY)
//        let url = "\(Constants.baseURL)/edit_category"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("UPDATE CATEGORY JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "true")
                    {
                        self.showAlert(title: "Oops".localized(), msg: jsonResponse["error_message"].stringValue)
                    }
                    else if(jsonResponse["error"].stringValue == "Unauthenticated")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else
                    {
                        if(self.delegate != nil)
                        {
                            self.delegate?.didFinishEditingCategories(selectionDone: true)
                            self.dismiss(animated: true, completion: nil);
                        }
                    }
                }
            }
            else{
                SwiftSpinner.hide()
                print(response.error.debugDescription)
                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                
            }
        }
    }
    
    
    
    func deleteCategory(){
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
        {
            headers = [
                "Authorization": accesstoken,
                "Accept": "application/json"
            ]
        }
        else
        {
            headers = [
                "Authorization": "",
                "Accept": "application/json"
            ]
        }
        
        let provServiceId = self.serviceDictionary["id"]?.stringValue
        var providerid = ""
        if SharedObject().hasData(value: provServiceId)
        {
            providerid = provServiceId!
        }
        let params: Parameters = [
            "provider_service_id": providerid
        ]
        SwiftSpinner.show("Removing service...".localized())
        let url = APIList().getUrlString(url: .DELETE_CATEGORY)
//        let url = "\(Constants.baseURL)/delete_category"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("DELETE CATEGORY JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "true" )
                    {
                        self.showAlert(title: "Oops".localized(), msg: jsonResponse["error_message"].stringValue)
                    }
                    else if(jsonResponse["error"].stringValue == "Unauthenticated")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        if(self.delegate != nil){                        self.delegate?.didFinishEditingCategories(selectionDone: true)
                            self.dismiss(animated: true, completion: nil);
                        }
                    }
                }
            }
            else{
                SwiftSpinner.hide()
                print(response.error.debugDescription)
                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                
            }
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == experienceFld)
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if (string == filtered)
            {
                let maxLength = 2
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
                
                //                return newString.length <= maxLength
            }
            else {
                
                return false
            }
            //            let maxLength = 3
            //            let currentString: NSString = textField.text! as NSString
            //            let newString: NSString =
            //                currentString.replacingCharacters(in: range, with: string) as NSString
            //            return newString.length <= maxLength
        }
        else if (textField == pricePerHourFld)
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if (string == filtered)
            {
                let maxLength = 5
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
                
                //                return newString.length <= maxLength
            }
            else {
                
                return false
            }
            /* let maxLength = 5
             let currentString: NSString = textField.text! as NSString
             let newString: NSString =
             currentString.replacingCharacters(in: range, with: string) as NSString
             return newString.length <= maxLength*/
        }
        else if textField == quickPitchFld
        {
            if Int(range.location) == 0 && (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            return true
        }
    }
    
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    
}
