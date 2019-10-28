//
//  AddressViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 15/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class AddressViewController: UIViewController
{
    
    @IBOutlet weak var titleLbl: UILabel!
    

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var zipcodeFld: UITextField!
    @IBOutlet weak var stateFld: UITextField!
    @IBOutlet weak var cityFld: UITextField!
    @IBOutlet weak var addressLine2Fld: UITextField!
    @IBOutlet weak var addressLine1Fld: UITextField!
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLine2Fld.keyboardType = .asciiCapable
        addressLine1Fld.keyboardType = .asciiCapable
        cityFld.keyboardType = .asciiCapable
        stateFld.keyboardType = .asciiCapable
        if #available(iOS 10.0, *) {
            zipcodeFld.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
        
        titleLbl.text = "Address".localized()
        addressLine1Fld.placeholder = "Address Line 1".localized()
        addressLine2Fld.placeholder = "Address Line 2".localized()
        cityFld.placeholder = "City".localized()
        stateFld.placeholder = "State".localized()
        zipcodeFld.placeholder = "Zipcode".localized()
        btnSave.setTitle("SAVE".localized(), for: .normal)
        
        titleLbl.font = FontBook.Medium.of(size: 20)
        addressLine1Fld.font = FontBook.Regular.of(size: 17)
        addressLine2Fld.font = FontBook.Regular.of(size: 17)
        cityFld.font = FontBook.Regular.of(size: 17)
        stateFld.font = FontBook.Regular.of(size: 17)
        zipcodeFld.font = FontBook.Regular.of(size: 17)
        btnSave.titleLabel!.font = FontBook.Regular.of(size: 17)
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.getAddress()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnSave.backgroundColor = mycolor
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    func getAddress(){
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
        
        SwiftSpinner.show("Fetching your Profile...".localized())
        let url = APIList().getUrlString(url: .VIEWPROFILE)
//        let url = "\(Constants.baseURL)/viewprofile"
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("ADDRESS JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    print("details",jsonResponse)
                    if(jsonResponse["error"].stringValue == "true" )
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
                        
                        if jsonResponse["provider_details"]["addressline1"].stringValue == "address not specified"
                        {
                            self.addressLine1Fld.placeholder = jsonResponse["provider_details"]["addressline1"].stringValue
                        }
                        else
                        {
                            self.addressLine1Fld.text = jsonResponse["provider_details"]["addressline1"].stringValue
                        }
                        
                        if jsonResponse["provider_details"]["addressline2"].stringValue == "address not specified"
                        {
                            self.addressLine2Fld.placeholder = jsonResponse["provider_details"]["addressline2"].stringValue
                        }
                        else
                        {
                            self.addressLine2Fld.text = jsonResponse["provider_details"]["addressline2"].stringValue
                        }
                        
                        if jsonResponse["provider_details"]["city"].stringValue == "city not specified"
                        {
                            self.cityFld.placeholder = jsonResponse["provider_details"]["city"].stringValue
                        }
                        else
                        {
                            self.cityFld.text = jsonResponse["provider_details"]["city"].stringValue
                        }
                        
                        if jsonResponse["provider_details"]["state"].stringValue == "state not specified"
                        {
                            self.stateFld.placeholder = jsonResponse["provider_details"]["state"].stringValue
                        }
                        else
                        {
                            self.stateFld.text = jsonResponse["provider_details"]["state"].stringValue
                        }
                        
                        if jsonResponse["provider_details"]["zipcode"].stringValue == "zipcode not specified"
                        {
                            self.zipcodeFld.placeholder = jsonResponse["provider_details"]["zipcode"].stringValue
                        }
                        else
                        {
                            self.zipcodeFld.text = jsonResponse["provider_details"]["zipcode"].stringValue
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
    @IBAction func saveAddress(_ sender: Any) {
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
        
        let addressline1 = addressLine1Fld.text!
        let addressline2 = addressLine2Fld.text!
        let city = cityFld.text!
        let state = stateFld.text!
        let zipcode = zipcodeFld.text!
        
        let params: Parameters = [
            "addressline1": addressline1,
            "addressline2":addressline2,
            "city":city,
            "state":state,
            "zipcode":zipcode
        ]
        SwiftSpinner.show("Updating your Address...".localized())
        let url = APIList().getUrlString(url: .UPDATE_ADDRESS)
//        let url = "\(Constants.baseURL)/update_address"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("CANCEL JSON: \(json)") // serialized json response
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
                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if (textField == addressLine1Fld || textField == addressLine2Fld || textField == cityFld || textField == stateFld || textField == zipcodeFld)
        {
//            if  (string == " ")
//            {
//                return false
//            }
//            else
//            {
//                return true
//            }
            
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
    

}
