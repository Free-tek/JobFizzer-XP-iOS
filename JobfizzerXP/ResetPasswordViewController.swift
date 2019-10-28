//
//  ResetPasswordViewController.swift
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

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var passwordFld: UITextField!
    
    @IBOutlet weak var lblreset: UILabel!
    @IBOutlet weak var confrimPasswordFld: UITextField!
    var email : String!
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblreset.text = "Reset Password".localized()
        passwordFld.placeholder = "NEW PASSWORD".localized()
        confrimPasswordFld.placeholder = "CONFIRM PASSWORD".localized()
        
        
        lblreset.font = FontBook.Medium.of(size: 20)
        passwordFld.font = FontBook.Regular.of(size: 17)
        confrimPasswordFld.font = FontBook.Regular.of(size: 17)       
        btnReset.titleLabel!.font = FontBook.Medium.of(size: 17)

        
        
        
//        btnReset
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnReset.backgroundColor = mycolor
        }
    }
    @IBAction func goToBack(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func resetPassword(_ sender: Any) {
        let pass = passwordFld.text!
        let confirmpass = confrimPasswordFld.text!
        
        
        let validationFailed = "Validation Failed".localized();
        
        if(pass.count == 0)
        {
            showAlert(title: validationFailed, msg: "Please enter a New Password".localized())
        }else if (pass.count < 6){
            self.showAlert(title: validationFailed,msg: "New Password Should be minimum 6 characters".localized())
        }
        else if(confirmpass.count == 0)
        {
            showAlert(title: validationFailed, msg: "Please enter a Confirm Password".localized())
        }
        else{
            if(pass == confirmpass)
            {
                var Email = ""
                if SharedObject().hasData(value: email){
                    Email = email!
                }
                let params: Parameters = [
                    "email": Email,
                    "confirmpassword": confirmpass,
                    "password": pass
                ]
                SwiftSpinner.show("Changing your password...".localized())
                let url = APIList().getUrlString(url: .RESETPASSWORD)
//                let url = "\(Constants.baseURL)/resetpassword"
                Alamofire.request(url,method: .post,parameters:params).responseJSON { response in
                    
                    if(response.result.isSuccess)
                    {
                        SwiftSpinner.hide()
                        if let json = response.result.value {
                            print("RESET PASSWORD JSON: \(json)") // serialized json response
                            let jsonResponse = JSON(json)
                            if(jsonResponse["error"].stringValue == "true")
                            {
                                let errorMessage = jsonResponse["error_message"].stringValue
                                self.showAlert(title: "Login Failed".localized(),msg: errorMessage)
                            }
                            else{
                                let alert = UIAlertController(title: "Password Changed Successfully".localized(), message: "Please login".localized(), preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: {
                                    (alert: UIAlertAction!) in
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                                    self.present(vc, animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
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
                showAlert(title: validationFailed, msg: "New Password and Confirm Password should be same")
            }
        }
    }
    
}

