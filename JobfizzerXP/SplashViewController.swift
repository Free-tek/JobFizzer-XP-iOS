//
//  SplashViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class SplashViewController: UIViewController, OfflineViewControllerDelegate {
   
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getAppSettings(){
        if Reachability.isConnectedToNetwork(){
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
        let url = APIList().getUrlString(url: .APPSETTINS)
            print("Splash URL:",url)
//        let url = "\(Constants.baseURL)/appsettings"
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                if let json = response.result.value {
                    print("APP SETTINGS JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    print(jsonResponse)
                    if(jsonResponse["message"].stringValue == "Unauthenticated.")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if(jsonResponse["error"].stringValue == "true" )
                    {
                        self.showAlert(title: "Oops".localized(), msg: jsonResponse["error_message"].stringValue)
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
                        let alert = UIAlertController(title: "Attenction!".localized(), message: "HI! Your Account Has Been Suspended By Admin. For Further Information Please Contact admin@uberdoo.com".localized(), preferredStyle: UIAlertControllerStyle.alert)
                        
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
                        print("\( Constants.timeSlots.count)")
                        print("\(Constants.timeSlots)")
                        let statusArray = jsonResponse["status"].arrayValue;
                        print(statusArray)
                        
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
                            else{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            else{
                print(response.error!.localizedDescription)
                //                self.showAlert(title: "Oops", msg: response.error!.localizedDescription)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//
//                self.present(vc, animated: true, completion: nil)
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        }
        else {
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            present(Dvc, animated: true, completion: nil)
        }
    }
    func tryAgain() {
        getAppSettings()
        dismiss(animated: true, completion: nil)
    }
  /*  func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    } */
    
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
        
        var params: Parameters!
        if let deviceToken = InstanceID.instanceID().token()
        {
            params = [
                "fcm_token": deviceToken,
                "os":"iOS"
            ]
        }
        else{
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        getAppSettings()
    }

}
