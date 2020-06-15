//
//  AddCategoryViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 07/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Localize_Swift

protocol AddressSelectionDelegate: class {
    func didFinishSelectingCategories(selctedCategory: JSON)
}

class AddCategoryViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate
{
   
    

    weak var delegate: AddressSelectionDelegate?
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblAddCategory: UILabel!
    @IBOutlet weak var quickPitchFld: UITextField!
    @IBOutlet weak var pricePerHourFld: UITextField!
    @IBOutlet weak var experienceFld: UITextField!
    @IBOutlet weak var subcategoryFld: UITextField!
    @IBOutlet weak var categoryFld: UITextField!
    
    var listCategories : [JSON] = []
    var listSubCategories : [JSON] = []
    var category : JSON!  = JSON.init()
    var mycolor = UIColor()
    var selectedCategoryId = "0"
    var selectedSubCategoryId = "0"
    
    let ACCEPTABLE_CHARACTERS = "0123456789"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        experienceFld.delegate = self
        pricePerHourFld.delegate = self
        quickPitchFld.delegate = self
        
        if #available(iOS 10.0, *) {
            experienceFld.keyboardType = .asciiCapableNumberPad
             pricePerHourFld.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
       
        quickPitchFld.keyboardType = .asciiCapable
        
        btnDone.setTitle("DONE".localized(), for: .normal)
        btnDone.titleLabel?.font = FontBook.Medium.of(size: 17)
        lblAddCategory.text = "ADD CATEGORY DETAILS".localized()
        lblAddCategory.font = FontBook.Medium.of(size: 17)
        categoryFld.placeholder = "Category".localized()
        categoryFld.font = FontBook.Regular.of(size: 17)
        
        subcategoryFld.placeholder = "Sub Category".localized()
        subcategoryFld.font = FontBook.Regular.of(size: 17)
        
        experienceFld.placeholder = "Experience in Months".localized()
        experienceFld.font = FontBook.Regular.of(size: 17)
        
        pricePerHourFld.placeholder = "Price / Hr (in ₦)".localized()
        pricePerHourFld.font = FontBook.Regular.of(size: 15)
        
        quickPitchFld.placeholder = "Quick Pitch".localized()
        quickPitchFld.font = FontBook.Regular.of(size: 15)
        // Do any additional setup after loading the view.
        getCategories()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnDone.backgroundColor = mycolor
            
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
    
    
    func getCategories()
    {
     
        
        
        var headers : HTTPHeaders!
        if let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
        {
            headers = [
                "Authorization": accesstoken,
                "Accept": "application/json"
            ]
            print(accesstoken)
        }
        else
        {
            headers = [
                "Authorization": "",
                "Accept": "application/json"
            ]
        }
        
        
        SwiftSpinner.show("Fetching...")
        let url = APIList().getUrlString(url: .LISTCATEGORY)
//        let url = "\(Constants.baseURL)/listcategory"
        Alamofire.request(url,method: .get, headers:headers).responseJSON
        { response in
        
            
            SwiftSpinner.hide()

            if(response.result.isSuccess)
            {
                if let json = response.result.value {
                    print("CATEGORIES JSON: \(json)") // serialized json response
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
                        
                        self.listCategories = jsonResponse["list_category"].arrayValue;
                        if(self.listCategories.count > 0){
                            print(self.listCategories)
                        }
                    }
                }
            }
            else{
                print(response.error!.localizedDescription)
                //                self.showAlert(title: "Oops", msg: response.error!.localizedDescription)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func pressedOutside(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
    }
    @IBAction func categoryButtonPressed(_ sender: Any) {
        showPickerInActionSheet(sentBy: "category")
    }
    
    @IBAction func subCategoyButtonPressed(_ sender: Any) {
        if(self.categoryFld?.text?.count ==  0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Select a category")
        }else{
            showPickerInActionSheet(sentBy:"subCategory")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        if(self.categoryFld?.text?.count ==  0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Select a category")
        }
        else if(self.subcategoryFld?.text?.count ==  0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Select a sub category")
        }
        else if(self.experienceFld?.text?.count ==  0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Experience required")
        }
        else if(self.pricePerHourFld?.text?.count == 0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Price per hour required")
        }
        else if(self.pricePerHourFld?.text == "0")
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Price per hour should be greater than 0")
        }
        else if(self.quickPitchFld?.text?.count == 0)
        {
            self.showAlert(title: "Validation Failed".localized(), msg: "Quick Pitch required")
        }
        else{
            if(self.delegate != nil){
                self.category["id"].stringValue = self.selectedCategoryId
                self.category["category_id"].stringValue = self.selectedCategoryId
                self.category["sub_category_id"].stringValue = self.selectedSubCategoryId
                self.category["quickpitch"].stringValue = self.quickPitchFld.text!
                self.category["priceperhour"].stringValue = self.pricePerHourFld.text!
                self.category["experience"].stringValue = self.experienceFld.text!
                self.category["categoryName"].stringValue = self.categoryFld.text!
                self.category["subCategoryName"].stringValue = self.subcategoryFld.text!
                self.delegate!.didFinishSelectingCategories(selctedCategory: self.category)
                self.dismiss(animated: true, completion:nil)
            }
        }
        
    }
    
    func showPickerInActionSheet(sentBy: String) {
        let title = ""
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.isModalInPopover = true;
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        let pickerFrame: CGRect = CGRect.init(x:-10, y:52,width: self.view.frame.size.width ,height: 100); // CGRectMake(left), top, width, height) - left and top are like margins
        let picker: UIPickerView = UIPickerView(frame: pickerFrame);

// If there will be 2 or 3 pickers on this view, I am going to use the tag as a way
// to identify them in the delegate and datasource. /* This part with the tags is not required.
// I am doing it this way, because I have a variable, witch knows where the Alert has been invoked from.

        if(sentBy == "category"){
            picker.tag = 1;
        } else if (sentBy == "subCategory"){
            picker.tag = 2;
        } else {
            picker.tag = 0;
        }
 
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
 
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
 
        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRect.init(x:0,y: 5,width: self.view.frame.size.width, height:45);
        let toolView: UIView = UIView(frame: toolFrame);
 
        //add buttons to the view
        let buttonCancelFrame: CGRect = CGRect.init(x:0,y: 7,width: self.view.frame.size.width/2, height:30); //size & position of the button as placed on the toolView
 
        //Create the cancel button & set its title
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel".localized(), for: UIControlState.normal);
        buttonCancel.setTitleColor(UIColor.blue, for: UIControlState.normal);
        toolView.addSubview(buttonCancel); //add it to the toolView
 
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: #selector(AddCategoryViewController.cancelSelection), for: UIControlEvents.touchDown);
 
 
        //add buttons to the view
        let buttonOkFrame: CGRect = CGRect.init(x:(self.view.frame.size.width/2)-10, y:7, width:(self.view.frame.size.width/2), height:30); //size & position of the button as placed on the toolView
 
        //Create the Select button & set the title
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("OK".localized(), for: UIControlState.normal);
        buttonOk.setTitleColor(UIColor.blue, for: UIControlState.normal);
        toolView.addSubview(buttonOk); //add to the subview
 
        buttonOk.addTarget(self, action: #selector(AddCategoryViewController.okSelection), for: UIControlEvents.touchDown);
 
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
 
        if(sentBy == "category"){
            self.present(alert, animated: true, completion: nil)
        }else{
            if(self.listSubCategories.count > 0){
                self.present(alert, animated: true, completion: nil)
            }else{
                //self.present(alert, animated: true, completion: nil)
                
                self.showAlert(title: "Validation Failed".localized(), msg: "Selected Category doesn't have any Sub-Categories,Please select another category.")
            }
        }
 }
 

    @objc func okSelection(sender: UIButton){
        self.dismiss(animated: true, completion: nil);
    }
    
    @objc func cancelSelection(sender: UIButton){
        print("Cancel");
        self.dismiss(animated: true, completion: nil);
    }
 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
 // returns number of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView.tag == 1)
        {
            if (self.listCategories.count > 0)
            {
                self.listSubCategories = self.listCategories[0]["list_subcategory"].arrayValue
                self.categoryFld.text = self.listCategories[0]["category_name"].stringValue
                self.selectedCategoryId = self.listCategories[0]["id"].stringValue
                self.selectedSubCategoryId = "0"
                self.subcategoryFld.text = ""
                return self.listCategories.count;
            }
            else
            {
                return self.listCategories.count;
            }
        }
        else if(pickerView.tag == 2)
        {
            if (self.listSubCategories.count > 0)
            {
                self.selectedCategoryId = self.listSubCategories[0]["category_id"].stringValue
                self.selectedSubCategoryId = self.listSubCategories[0]["id"].stringValue
                self.subcategoryFld.text = self.listSubCategories[0]["sub_category_name"].stringValue
                return self.listSubCategories.count;
            }
            else
            {
                return self.listSubCategories.count;
            }
        }
        else
        {
            return 0;
        }
    }
 
 // Return the title of each row in your picker ... In my case that will be the profile name or the username string
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
 {
    if(pickerView.tag == 1)
    {
        return self.listCategories[row]["category_name"].stringValue
    }
    else if(pickerView.tag == 2)
    {
        return self.listSubCategories[row]["sub_category_name"].stringValue
    }
        return "";
}
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1)
        {
            if self.listCategories.count > 0
            {
                self.listSubCategories = self.listCategories[row]["list_subcategory"].arrayValue
                self.categoryFld.text = self.listCategories[row]["category_name"].stringValue
                self.selectedCategoryId = self.listCategories[row]["id"].stringValue
                self.selectedSubCategoryId = "0"
                self.subcategoryFld.text = ""
            }
        }
        else if(pickerView.tag == 2)
        {
            if(row < self.listSubCategories.count)
            {
                if self.listSubCategories.count > 0
                {
                    self.selectedCategoryId = self.listSubCategories[row]["category_id"].stringValue
                    self.selectedSubCategoryId = self.listSubCategories[row]["id"].stringValue
                    self.subcategoryFld.text = self.listSubCategories[row]["sub_category_name"].stringValue
                }
            }
        }

        print(self.selectedCategoryId)
        print(self.selectedSubCategoryId)
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
 
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.text = textField.text!.trimmingCharacters(in: .whitespaces)
    }
    
 }
 

