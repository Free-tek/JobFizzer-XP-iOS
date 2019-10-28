//
//  SigninViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Firebase
import FirebaseMessaging
import Localize_Swift
import CoreLocation

class SigninViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var btnDontHaveAccount: UIButton!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var UsernameFld: UITextField!
    
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblUber: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    var mycolor = UIColor()
     let locationManager = CLLocationManager()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        UsernameFld.keyboardType = .asciiCapable
        passwordFld.keyboardType = .asciiCapable
        
        passwordFld.delegate = self
        UsernameFld.delegate = self
        UsernameFld.autocorrectionType = .no
        lblSignin.text = "Sign in".localized()
        lblUber.text = "Jobfizzer XP".localized()
        UsernameFld.placeholder = "Email ID".localized()
        passwordFld.placeholder = "PASSWORD".localized()
        btnForgot.setTitle("Forgot Password?".localized(), for: .normal)
        btnDontHaveAccount.setTitle("Don't have an account?".localized(), for: .normal)
        btnLogin.setTitle("LOGIN".localized(), for: .normal)
        lblUber.font = FontBook.Medium.of(size: 22)
        lblSignin.font = FontBook.Medium.of(size: 20)
        UsernameFld.font = FontBook.Regular.of(size: 17)
        passwordFld.font = FontBook.Regular.of(size: 17)
        btnLogin.titleLabel?.font = FontBook.Medium.of(size: 17)
        btnForgot.titleLabel?.font = FontBook.Medium.of(size: 14)
        btnDontHaveAccount.titleLabel?.font = FontBook.Medium.of(size: 14)
        
//        changeFont()
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnLogin.backgroundColor = mycolor
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
    func validateForm() -> Bool
    {
        
        let usermane = UsernameFld.text!.trimmingCharacters(in: .whitespaces)
        let validemail = validateEmail(enteredEmail: usermane)
        if usermane.isEmpty {
            showAlert(title: "Validation Failed".localized(),msg: "Enter email id".localized())
            return false
        }
        else if validemail == false
        {
            showAlert(title: "Validation Failed".localized(),msg: "Invalid Email".localized())
            return false
        }
        else if passwordFld.text!.isEmpty {
            showAlert(title: "Validation Failed".localized(),msg: "Please Enter Password".localized())
            return false
        }
        else
        {
            return true
        }
       /* if let text = UsernameFld.text, !text.isEmpty
        {
            return true
        }
        else{
            showAlert(title: "Validation Failed".localized(),msg: "Invalid Email".localized())
            return false
        }
        if let text = passwordFld.text, !text.isEmpty
        {
            return true
        }
        else{
            showAlert(title: "Validation Failed".localized(),msg: "Invalid Password".localized())
            return false
        }*/
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case UsernameFld:
            passwordFld.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func login(_ sender: Any) {
        
        
        let isValid = validateForm()
        if(isValid)
        {
            
            UsernameFld.text = UsernameFld.text!.trimmingCharacters(in: .whitespaces)
//            passwordFld.text = passwordFld.text!.trimmingCharacters(in: .whitespaces)

            
            let params: Parameters = [
                "email": UsernameFld.text!,
                "user_type": "Provider",
                "password": passwordFld.text!
            ]
            SwiftSpinner.show("Logging in...".localized())
            let url = APIList().getUrlString(url: .SIGNIN)
//            let url = "\(Constants.baseURL)/providerlogin"
            Alamofire.request(url,method: .post,parameters:params).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("LOGIN JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "true")
                        {
                            let errorMessage = jsonResponse["message"].stringValue
                            self.showAlert(title: "Login Failed".localized(),msg: jsonResponse["error_message"].stringValue)
                        }
                        else{
                            let access_token = "Bearer ".appending(jsonResponse["access_token"].stringValue)
                            let first_name = jsonResponse["first_name"].stringValue
                            
                            let last_name = jsonResponse["last_name"].stringValue
                            let image = jsonResponse["image"].stringValue
//                            let mobile = jsonResponse["mobile"].stringValue
                            let email = jsonResponse["email"].stringValue
                            let provider_id = jsonResponse["provider_id"].stringValue
                            
                            UserDefaults.standard.set(access_token, forKey: "access_token")
                            UserDefaults.standard.set(first_name, forKey: "first_name")
                            UserDefaults.standard.set(last_name, forKey: "last_name")
                            UserDefaults.standard.set(image, forKey: "image")
                            UserDefaults.standard.set(provider_id, forKey: "provider_id")
                            
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            self.updateDeviceToken()
                            
                            self.getAppSettings()
                            
                            //                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                            //                            self.present(vc, animated: true, completion: nil)
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
        
        
    }
    
    func getAppSettings()
    {
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
        
//        let url = "\(Constants.baseURL)/appsettings"
    let url = APIList().getUrlString(url: .APPSETTINS)
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                if let json = response.result.value {
                    print("APP SETTINGS JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "true" )
                    {
                        self.showAlert(title: "Oops", msg: jsonResponse["error_message"].stringValue)
                    }
                    else if(jsonResponse["error"].stringValue == "Unauthenticated")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if(jsonResponse["delete_status"].stringValue == "active")
                    {
                        print(jsonResponse["delete_status"].stringValue)
                        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                        let alert = UIAlertController(title: "Attenction!".localized(), message: "HI! Your Account Has Been Suspended By Admin. For Further Information Please Contact admin@jobfizzer.com".localized(), preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                            self.present(vc, animated: true, completion: nil)
                        }))
                        // alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else{
                        Constants.locations = jsonResponse["location"].arrayValue
                        Constants.timeSlots = jsonResponse["timeslots"].arrayValue
                        
                        let statusArray = jsonResponse["status"].arrayValue;
                        
                        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                        if(isLoggedIn)
                        {
                            self.updateDeviceToken()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                            MainViewController.status = statusArray
                            self.present(vc, animated: true, completion: nil)
                        }
                        else{
                            let isLoggedInSkipped = UserDefaults.standard.bool(forKey: "isLoggedInSkipped")
                            if(isLoggedInSkipped)
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                                MainViewController.status = statusArray
                                self.present(vc, animated: true, completion: nil)
                            }                            
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
    
    func updateDeviceToken(){
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
        
        let deviceToken = InstanceID.instanceID().token()
        
        var params = Parameters()
        
        if SharedObject().hasData(value: deviceToken)
        {
            params = [
                "fcm_token": deviceToken!,
                "os":"iOS"
            ]
        }
        else
        {
            params = [
                "fcm_token": "",
                "os":"iOS"
            ]
        }
        let url = APIList().getUrlString(url: .UPDATEDEVICETOKEN)
//        let url = "\(Constants.baseURL)/updatedevicetoken"
        Alamofire.request(url,method: .post,parameters:params, headers:headers).responseJSON { response in
            
            print(response.description)
            
        }
        
    }
    

    @IBAction func goToSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == UsernameFld
        {
            if  (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
            
           /* if Int(range.location) == 0 && (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
 */
        }
        else
        {
            return true
        }
    }
}
