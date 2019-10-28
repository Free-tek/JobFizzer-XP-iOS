//
//  ForgotPasswordViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Localize_Swift

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var lblForgot: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var btnemail: UIButton!
    @IBOutlet weak var countryCode: UIButton!
    @IBOutlet weak var phoneNumberField: UITextField!
    
    let ACCEPTABLE_CHARACTERS1 = ""
    
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        phoneNumberField.delegate = self
        lblForgot.text = "Forgot Password".localized()
        lblForgot.font = FontBook.Medium.of(size: 20)
        lblEmail.text = "Enter your email to receive a verification code".localized()
        lblEmail.font = FontBook.Medium.of(size: 17)
        btnnext.titleLabel?.font = FontBook.Regular.of(size: 17)
        btnemail.titleLabel?.font = FontBook.Regular.of(size: 18)
        phoneNumberField.autocorrectionType = .no
        btnnext.setTitle("Next".localized(), for: .normal)
        btnemail.setTitle("Email".localized(), for: .normal)
        phoneNumberField.font = FontBook.Regular.of(size: 17)
        
        phoneNumberField.keyboardType = .emailAddress
        
        // Do any additional setup after loading the view.
//        changeFont()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnnext.backgroundColor = mycolor
            btnemail.backgroundColor = mycolor
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
  /*  func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    @IBAction func goToOtpSCreen(_ sender: Any)
    {
        let validemail = validateEmail(enteredEmail: phoneNumberField.text!)
        if let text = phoneNumberField.text, !text.isEmpty
        {
            if(validemail == true){
                let params: Parameters = [
                    "email": phoneNumberField.text!
                ]
                print(params)
                SwiftSpinner.show("Sending OTP...".localized())
                //            let url = "\(Constants.baseURL)/forgotpassword"
                let url = APIList().getUrlString(url: .FORGETPASSWORD)
                print(url)
                Alamofire.request(url,method: .post,parameters:params).responseJSON { response in
                    
                    if(response.result.isSuccess)
                    {
                        SwiftSpinner.hide()
                        if let json = response.result.value {
                            print("SEND OTP JSON: \(json)") // serialized json response
                            let jsonResponse = JSON(json)
                            if(jsonResponse["error"].stringValue == "true")
                            {
                                let errorMessage = jsonResponse["error_message"].stringValue
                                self.showAlert(title: "Failed".localized(),msg: errorMessage)
                            }
                            else{
                                let otp = jsonResponse["otp"].stringValue
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                vc.otp = otp
                                vc.email = self.phoneNumberField.text
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                    else{
                        SwiftSpinner.hide()
                        print(response.error.debugDescription)
                        self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                    }
                    
                }
            }else{
                showAlert(title: "Validation Failed".localized(),msg: "Please enter Valid Email ID".localized())
            }
            
        }
        else{
            showAlert(title: "Validation Failed".localized(),msg: "Please enter Email ID".localized())
        }
        
    }
    @IBAction func showCountyCodes(_ sender: Any) {
        
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.present(vc, animated: true, completion: nil)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == phoneNumberField
        {
            if  (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
//            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
//            let filtered = string.components(separatedBy: cs).joined(separator: "")
//            if ((string == filtered))
//            {
//                let maxLength = 15
//                let currentString: NSString = textField.text! as NSString
//                let newString: NSString =
//                    currentString.replacingCharacters(in: range, with: string) as NSString
//                return newString.length <= maxLength
//                
//                //                return newString.length <= maxLength
//            }
//            else {
//                return false
//            }
        }
        else
        {
            return true
        }
    }
}

