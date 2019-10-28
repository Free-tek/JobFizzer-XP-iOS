//
//  OTPViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import Localize_Swift

class OTPViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var otpField: UITextField!
    
    @IBOutlet weak var lblVerify: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    
    var otp : String!
    var email : String!
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        otpField.text = otp
        otpField.delegate = self
        lblVerify.text = "Enter verification code".localized()
        btnVerify.setTitle("VERIFY".localized(), for: .normal)
        lblVerify.font = FontBook.Medium.of(size: 17)
        btnVerify.titleLabel?.font = FontBook.Regular.of(size: 17)
        otpField.font = FontBook.Regular.of(size: 17)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated:true,completion:nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnVerify.backgroundColor = mycolor
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
//        let  char = string.cString(using: String.Encoding.utf8)!
//        if(textField == otpField)
//        {
//            if(textField.text!.count <= 5) {
//                return true
//            }else if(char.elementsEqual([0])){
//                return true
//            }else{
//                return false
//            }
//
//        }
        if (textField == otpField)
        {
            let maxLength = 6
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else
        {
            return true
        }
        
        
    }
    
    @IBAction func verify(_ sender: Any) {
        if let text = otpField.text, !text.isEmpty
        {
            var Email = ""
            if SharedObject().hasData(value: email){
                Email = email!
            }
            let params: Parameters = [
                "email": Email,
                "otp": otpField.text!
            ]
            SwiftSpinner.show("Sending OTP...".localized())
            let url = APIList().getUrlString(url: .OTPCHECK)
//            let url = "\(Constants.baseURL)/otpcheck"
            Alamofire.request(url,method: .post,parameters:params).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("OTP VERIFY JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "true")
                        {
                            let errorMessage = jsonResponse["error_message"].stringValue
                            self.showAlert(title: "Failed".localized(),msg: errorMessage)
                        }
                        else{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
                            vc.email = self.email
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
        }
        else{
            showAlert(title: "Validation Failed".localized(),msg: "Please enter Otp".localized())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

