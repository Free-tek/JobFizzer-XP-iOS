//
//  MainViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications
import GoogleMaps




class MainViewController: UITabBarController, UITabBarControllerDelegate,UNUserNotificationCenterDelegate {
    
    static var startChat = false
    static var changePage = true
    static var reloadPage = false
    static var status : [JSON]! = []
    var mycolor = UIColor()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;
    
        let view = UIView()
//        view.frame = CGRect(x: self.view.frame.size.width - 150, y: self.view.frame.size.height - 120, width: 100, height: 50)
        let button = UIButton(type: .custom)
        button.setTitle("Floating", for: .normal)
        button.setTitleColor(UIColor.green, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.8
        button.layer.shadowOffset = CGSize.zero
        button.sizeToFit()
        button.frame = CGRect(origin: CGPoint(x: 10, y: 10), size: button.bounds.size)
        button.autoresizingMask = []
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(btnOnline), for: .touchUpInside)
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate  = self
        }
        

        // Do any additional setup after loading the view.
    }
    @objc func btnOnline()
    {
    showAlert(title: "Oops", msg: "you will go for onlie")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(MainViewController.changePage)
        {
            self.selectedIndex = 0
        }
        
        if(MainViewController.reloadPage)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
            MainViewController.reloadPage = false
        }
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            tabBarController?.tabBar.tintColor = mycolor
        }
        
        
      
        
        
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        let userInfo = notification.request.content.userInfo
        
        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
        
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let receiver_id = dct.object(forKey: "sender_id") as! String
                
                if appDelegate.chatReceiveID == ""
                {
                    
                }
                else
                {
                    completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
                    
                }
                
            }
            else
            {
                completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
                
            }
        }
        else
        {
            
            completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
            
            
            
        }
        
        
        
        
        
        
        
    }
    
}
