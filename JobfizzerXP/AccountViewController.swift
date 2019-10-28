//
//  AccountViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON
import Nuke
import UserNotifications
import SDWebImage

class AccountViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UNUserNotificationCenterDelegate,updateImageDelegate,OfflineViewControllerDelegate
{
    func tryAgain() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateImage() {
        
        if let image = UserDefaults.standard.string(forKey: "image") as String!{
            
            if let imageUrl = URL.init(string: image) as URL!{
                Nuke.loadImage(with: imageUrl, into: self.userPicture)
            }else{
                if UserDefaults.standard.object(forKey: "myColor") != nil
                {
                    let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                    mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                    changeTintColor(userPicture, arg: mycolor)
                }
            }
        }
        if let first_name = UserDefaults.standard.string(forKey: "first_name") as String!
        {
            if let  last_name = UserDefaults.standard.string(forKey: "last_name") as String!{
                nameLbl.text = "\(String(describing: first_name)) \(String(describing: last_name))"
            }
            else{
                nameLbl.text = "\(String(describing: first_name))"
            }
        }
        else{
            nameLbl.text = "Guest User".localized()
        }
        
    }
 
    @IBOutlet weak var themeView: UIView!
  
    var changeTheme: Bool = false
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    var titles :[String] = []
    var images :NSArray!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var VwchangeTheme: UIView!
    
    @IBOutlet weak var btnclr1: UIButton!
    @IBOutlet weak var btnclr2: UIButton!
    @IBOutlet weak var btnclr6: UIButton!
    @IBOutlet weak var btnclr5: UIButton!
    @IBOutlet weak var btnclr4: UIButton!
    @IBOutlet weak var btnclr3: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    var color1: UIColor = UIColor.init(red: 107 / 255, green: 127 / 255, blue: 252 / 255, alpha: 1.0)
    var color2: UIColor = UIColor.init(red: 252 / 255, green: 107 / 255, blue: 180 / 255, alpha: 1.0)
    var color3: UIColor = UIColor.init(red: 48 / 255, green: 58 / 255 , blue: 82 / 255, alpha: 1.0)
    var color4: UIColor  = UIColor.init(red: 54 / 255, green: 209 / 255, blue: 196 / 255, alpha: 1.0)
    var color5: UIColor = UIColor.init(red: 165 / 255, green: 107 / 255, blue: 252 / 255, alpha: 1.0)
    var color6: UIColor = UIColor.init(red: 252 / 255, green: 107 / 255, blue: 107 / 255 , alpha: 1.0)
    var mycolor = UIColor.init(red: 107 / 255, green: 127 / 255, blue: 252 / 255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewProfile()
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        nameLbl.font = FontBook.Medium.of(size: 23)
        
        
        if let image = UserDefaults.standard.string(forKey: "image") as String!{
            
            if let imageUrl = URL.init(string: image) as URL!{
                Nuke.loadImage(with: imageUrl, into: self.userPicture)
            }
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate  = self
        }
        
        if let first_name = UserDefaults.standard.string(forKey: "first_name") as String!
        {
            if let  last_name = UserDefaults.standard.string(forKey: "last_name") as String!{
                nameLbl.text = "\(String(describing: first_name)) \(String(describing: last_name))"
            }
            else{
                nameLbl.text = "\(String(describing: first_name))"
            }
        }
        else{
            nameLbl.text = "Guest User".localized()
        }
        btnclr1.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr1.layer.masksToBounds = true
        btnclr2.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr2.layer.masksToBounds = true
        btnclr3.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr3.layer.masksToBounds = true
        btnclr4.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr4.layer.masksToBounds = true
        btnclr5.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr5.layer.masksToBounds = true
        btnclr6.layer.cornerRadius = btnclr1.frame.size.width / 2
        btnclr6.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        let isLoggedInSkipped = UserDefaults.standard.bool(forKey: "isLoggedInSkipped")
        if(isLoggedInSkipped)
        {
            self.titles = NSArray(objects: "About Us","Help and FAQ","Login") as! [String]
            self.images = NSArray(objects:"about_us","help","log_out")
        }
        else{
            
            self.titles = NSArray(objects: "Profile","Change Password","Address","Appointments","Services","Schedule","About Us","Change Theme","Logout") as! [String]//"Profile",
            
            
            self.images = NSArray(objects:"new_profile","new_change_passsword","new_address","appointments","new_services","new_schedule","new_about_us","Themes-1","new_logout")//"new_profile",
            
            
            /*          self.titles = NSArray(objects: "Profile","Change Password","Address","Services","About Us","Change Theme","Logout") as! [String]//"Profile",
             
             
             self.images = NSArray(objects:"new_profile","new_change_passsword","new_address","new_services","new_about_us","themes","new_logout")//"new_profile",
             
             */
            
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewProfile()
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            if let image = UserDefaults.standard.string(forKey: "image") as String!{
                
                if let imageUrl = URL.init(string: image) as URL!{
                    Nuke.loadImage(with: imageUrl, into: self.userPicture)
                }else {
                    changeTintColor(userPicture, arg: mycolor)
                }
            }
            else {
                changeTintColor(userPicture, arg: mycolor)
            }
            tabBarController?.tabBar.tintColor = mycolor
        }
        else{
            if let image = UserDefaults.standard.string(forKey: "image") as String!
            {
                
                if let imageUrl = URL.init(string: image) as URL!
                {
                    Nuke.loadImage(with: imageUrl, into: self.userPicture)
                }
            }
        }
        
    }
    func chageColor()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnclr2(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color2)
        mycolor = color2
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        self.chageColor()
    }
    
    @IBAction func btnclr3(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color3)
        mycolor = color3
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        self.chageColor()
    }
    
    @IBAction func btnclr6(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color6)
        mycolor = color6
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        self.chageColor()
    }
    
    @IBAction func btnclr5(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color5)
        mycolor = color5
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        self.chageColor()
    }
    
    @IBAction func btnclr4(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color4)
        mycolor = color4
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        self.chageColor()
    }
    
    @IBAction func btnclr1(_ sender: Any)
    {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color1)
        mycolor = color1
        UserDefaults.standard.set(colorData, forKey: "myColor")
        VwchangeTheme.isHidden = true
        themeView.isHidden = true
        
        self.chageColor()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
        
        
        cell.selectionStyle = .none
        
        
        cell.title.text = self.titles[indexPath.row].localized()
        let imagename = self.images.object(at: indexPath.row) as! String
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            
            
            let imagename = self.images.object(at: indexPath.row) as! String
            cell.icon.image = UIImage(named:imagename)
            changeTintColor(cell.icon, arg: mycolor)
        }
        else {
            let imagename = self.images.object(at: indexPath.row) as! String
            cell.icon.image = UIImage(named:imagename)
        }
        
        
        return cell
        
    }
    func changeTintColor(_ img: UIImageView?, arg color: UIColor?) {
        if let aColor = color {
            img?.tintColor = aColor
        }
        var newImage: UIImage? = img?.image?.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions((img?.image?.size)!, false, (img?.image?.scale)!)
        color?.set()
        newImage?.draw(in: CGRect(x: 0, y: 0, width: img?.image?.size.width ?? 0.0, height: img?.image?.size.height ?? 0.0))
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        img?.image = newImage
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.titles = NSArray(objects: "View Profile","Change Password","About Us","Help and FAQ","Logout")
        
        if(self.titles[indexPath.row] == "Profile")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
                
                vc.updateDelegate = self
                
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Change Password")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "About Us")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                vc.titleString = "About Us"
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }
            else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Address")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewController") as! AddressViewController
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }
            else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Appointments")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
                //            MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Change Theme")
        {
            if changeTheme
            {
                changeTheme = false
                VwchangeTheme.isHidden = true
                themeView.isHidden = true
                
            }else {
                changeTheme = true
                VwchangeTheme.isHidden = false
                self.setView(view: themeView, hidden: false)
                
            }
            
        }
        else if(self.titles[indexPath.row] == "Services"){
            if Reachability.isConnectedToNetwork() {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServicesViewController") as! ServicesViewController
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Schedule"){
            if Reachability.isConnectedToNetwork() {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SchedulesViewController") as! SchedulesViewController
                MainViewController.changePage = false
                self.present(vc, animated: true, completion: nil)
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        else if(self.titles[indexPath.row] == "Logout" || self.titles[indexPath.row] == "Login")
        {
            if Reachability.isConnectedToNetwork() {
                print(self.titles[indexPath.row])
                let isLoggedInSkipped = UserDefaults.standard.bool(forKey: "isLoggedInSkipped")
                if(isLoggedInSkipped)
                {
                    self.login()
                }
                else{
                    self.logout()
                }
            }else {
                
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
                //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
            }
        }
        
    }
    
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        if(self.titles[indexPath.row] == "Change Theme"){
    //            VwchangeTheme.isHidden = true
    //        }
    //    }
    /* func showAlert(title: String,msg : String)
     {
     let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
     
     // add an action (button)
     alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
     
     // show the alert
     self.present(alert, animated: true, completion: nil)
     }*/
    
    func login(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.present(vc, animated: true, completion: nil)
    }
    func logout()
    {
        let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
        print(accesstoken!)
        let headers: HTTPHeaders = [
            "Authorization": accesstoken!,
            "Accept": "application/json"
        ]
        
        SwiftSpinner.show("Logging out...".localized())
        let url = APIList().getUrlString(url: .LOGOUT)
        
        //        let url = "\(Constants.baseURL)/logout"
        Alamofire.request(url,method: .get,headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("LOGOUT JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    let domain = Bundle.main.bundleIdentifier!
                    UserDefaults.standard.removePersistentDomain(forName: domain)
                    UserDefaults.standard.synchronize()
                    
                    
                    if(jsonResponse["error"].stringValue == "Unauthenticated" || jsonResponse["error"].stringValue == "true")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                        let colorData = NSKeyedArchiver.archivedData(withRootObject: self.mycolor)
                        UserDefaults.standard.set(colorData, forKey: "myColor")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func termsAndConditions(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.titleString = "Terms & Conditions"
        MainViewController.changePage = false
        self.present(vc, animated: true, completion: nil)
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        
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
    
    
    @IBAction func closeAtn(_ sender: Any)
    {
        changeTheme = false
        self.setView(view: self.VwchangeTheme, hidden: true)
        self.setView(view: themeView, hidden: true)
    }
    
    
    func setView(view: UIView, hidden: Bool)
    {
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations:
            {
                view.isHidden = hidden
        })
    }
    
    func viewProfile()
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
        
        SwiftSpinner.show("Fetching Profile Details...".localized())
        //        let url = "\(Constants.baseURL)/viewprofile"
        let url = APIList().getUrlString(url: .VIEWPROFILE)
        Alamofire.request(url,method: .get, headers:headers).responseJSON
            {
                response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value
                    {
                        print("VIEW PROFILE JSON_ACCOUNTS: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "Unauthenticated" || jsonResponse["error"].stringValue == "true")
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                        else
                        {

                            if let image = jsonResponse["provider_details"]["image"].string
                            {
//                                if let imageUrl = URL.init(string: image)
//                                {
//                                    Nuke.loadImage(with: imageUrl, into: self.userPicture)
                                    self.userPicture?.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
                                print("Image:",image)
                            }
                            else
                            {
                                self.changeTintColor(self.userPicture, arg: self.mycolor)
                            }
//                            }
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

