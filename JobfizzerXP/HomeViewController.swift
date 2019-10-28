//
//  HomeViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import Nuke
import UserNotifications
import GoogleMaps
import GooglePlaces




class HomeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UNUserNotificationCenterDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,cancelproviderdele
{
    func cancel() {
        getMyBookings()
    }
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noBookingLbl: UILabel!
    
    @IBOutlet weak var vwtop: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    var lat = ""
    var log = ""
    
    
    var addressString : String = ""

    var buttonTag = 0
    
    var imageString = " "
    
    var bookings : [JSON] = []
    
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        noBookingLbl.text = "You Have no bookings Available".localized()
        
        
             noBookingLbl.font = FontBook.Medium.of(size: 18)
        
        vwtop.isHidden = true
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate  = self
        }
        
        
     
        
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized())
        refreshControl.addTarget(self, action:  #selector(HomeViewController.refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        getMyBookings()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.refresh(sender:)), name: NSNotification.Name(rawValue: "Refresh"), object: nil)

        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissBack(_:)), name: NSNotification.Name(rawValue: "dismissBack"), object: nil)

        

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ChatData(_:)), name: NSNotification.Name(rawValue: "ChatData"), object: nil)
        
        


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

    }
    override func viewWillAppear(_ animated: Bool)
    {
        if(MainViewController.reloadPage)
        {
            getMyBookings()
        }
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            tabBarController?.tabBar.tintColor = mycolor
        }
        
        if (MainViewController.startChat)
        {
            
            MainViewController.startChat = false
            
            if let reciever_id = appDelegate.chatData["reciever_id"] as? String
            {
                
                let StoaryBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = StoaryBoard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
                vc.receiverId = reciever_id
                vc.name = ""
                
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                //            vc.modalTransitionStyle = .crossDissolve
                //
                self.present(vc, animated: true, completion: nil)
                //
                //            self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
    }
    
    
    @objc func dismissBack(_ notification: NSNotification)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.ChatData(_:)), name: NSNotification.Name(rawValue: "ChatData"), object: nil)

    }
    
    
    @objc func ChatData(_ notification: NSNotification)
    {
        
        if let reciever_id = appDelegate.chatData["reciever_id"] as? String
        {
            
            let StoaryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = StoaryBoard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            vc.receiverId = reciever_id
            vc.name = ""

            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            
//            vc.modalTransitionStyle = .crossDissolve
//
            self.present(vc, animated: true, completion: nil)
//
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    /*
    @objc func ChatData(notification: NSNotification)
    {
        
        
        
        if let reciever_id = notification.userInfo?["reciever_id"] as? String
        {
            
            let StoaryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = StoaryBoard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            vc.receiverId = reciever_id
            vc.name = ""
            
            vc.modalTransitionStyle = .crossDissolve
            
            self.present(vc, animated: true, completion: nil)
            
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }*/
    
    
    @objc func refresh(sender: UIRefreshControl) {
        getMyBookings()
    }
    
    @objc func changeStatus(sender:UIButton!)
    {
        let status = self.bookings[sender.tag]["status"].stringValue
        if(status == "Accepted")
        {
            print("Start to Place Clicked \(sender.tag)")
            
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
            let bookingId = self.bookings[sender.tag]["id"].stringValue
            print(bookingId)
            var booking = ""
            if SharedObject().hasData(value: bookingId){
                booking = bookingId
            }
            let params: Parameters = [
                "id": booking
            ]
            SwiftSpinner.show("Updating your Booking Status...".localized())
//            let url = "\(Constants.baseURL)/starttocustomerplace"
            let url = APIList().getUrlString(url: .STARTTOCUSTOMERPLACE)
            Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    self.refreshControl.endRefreshing()
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("START TO CUSTOMER PLACE JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "true" )
                        {
                            self.showAlert(title: "Oops".localized(), msg: jsonResponse["error_message"].stringValue)
                        }
                        else if(jsonResponse["error"].stringValue == "Unauthenticated")
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController")     as! SigninViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                        else{
                            self.getMyBookings()
                        }
                    }
                }
                else{
                    self.refreshControl.endRefreshing()

                    SwiftSpinner.hide()
                    print(response.error.debugDescription)
                    self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                    
                }
            }
        }
        else
        {
            
            startJobPressed(sender: sender)
            
            /*
            print("Start Job \(sender.tag)")
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
            let bookingId = self.bookings[sender.tag]["id"].stringValue
            print(bookingId)
            let params: Parameters = [
                "id": bookingId
            ]
            SwiftSpinner.show("Updating your Booking Status...")
            let url = "\(Constants.baseURL)/startedjob"
            Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    self.refreshControl.endRefreshing()
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("START TO CUSTOMER PLACE JSON: \(json)") // serialized json response
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
                        else{
                            self.getMyBookings()
                        }
                    }
                }
                else{
                    SwiftSpinner.hide()
                    print(response.error.debugDescription)
                    self.showAlert(title: "Oops", msg: response.error!.localizedDescription)
                    
                }
            }*/
        }
    }
    
    
    @objc func startToPlacePressed(sender:UIButton!)
    {
        if(sender.titleLabel?.text == "SHOW DIRECTIONS"){
            let latitude = self.bookings[sender.tag]["user_latitude"].stringValue
            let longitude = self.bookings[sender.tag]["user_longitude"].stringValue
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                UIApplication.shared.openURL(URL(string:
                    "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!)
                
            } else {
                NSLog("Can't use comgooglemaps://");
                let directionsURL = "https://maps.apple.com/?saddr=&daddr=\(latitude),\(longitude)"
                guard let url = URL(string: directionsURL) else {
                    return
                }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else{
            print("Start to Place Clicked \(sender.tag)")
            
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
            let bookingId = self.bookings[sender.tag]["id"].stringValue
            print(bookingId)
            var booking = ""
            if SharedObject().hasData(value: bookingId){
                booking = bookingId
            }
            let params: Parameters = [
                "id": booking
            ]
            SwiftSpinner.show("Updating your Booking Status...".localized())
//            let url = "\(Constants.baseURL)/starttocustomerplace"
            let url = APIList().getUrlString(url: .STARTTOCUSTOMERPLACE)
            Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON
            {
                response in
                
                if(response.result.isSuccess)
                {
                    self.refreshControl.endRefreshing()
                    SwiftSpinner.hide()
                    if let json = response.result.value
                    {
                        print("START TO CUSTOMER PLACE JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "true" )
                        {
                            self.showAlert(title: "Oops".localized(), msg: jsonResponse["error_message"].stringValue)
                        }
                        else if(jsonResponse["error"].stringValue == "Unauthenticated")
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController")     as! SigninViewController
                            self.present(vc, animated: true, completion: nil)
                        }
                        else
                        {
                            self.getMyBookings()
                        }
                    }
                }
                else
                {
                    SwiftSpinner.hide()
                    print(response.error.debugDescription)
                    self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                }
            }
        }
    }
    
    func appSettings()
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
        let url = APIList().getUrlString(url: .APPSETTINS)
//        let url = "\(Constants.baseURL)/appsettings"
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                if let json = response.result.value {
                    print("APP SETTINGS JSON: \(json)") // serialized json response
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
                        
                        let statusArray = jsonResponse["status"].arrayValue;
                        if(statusArray.count > 0){
                            print(statusArray[0])
                            if(statusArray[0]["Blocked"]["status"].stringValue == "1")
                            {
                                
                            }
                            else if(statusArray[0]["Dispute"]["status"].stringValue == "1")
                            {
                                
                            }
                            else if(statusArray[0]["Waitingforpaymentconfirmation"]["status"].stringValue == "1")
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentConfirmationViewController") as! PaymentConfirmationViewController
                               
                                vc.bookingId = statusArray[0]["Waitingforpaymentconfirmation"]["booking_id"].stringValue
                                vc.modalPresentationStyle = .overCurrentContext
                            
                                self.present(vc, animated: true, completion: nil)
                            }
                            else if(statusArray[0]["Reviewpending"]["status"].stringValue == "1")
                            {
                                if(jsonResponse["booking_details"]["isProviderReviewed"].intValue == 0)
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
                                    vc.modalPresentationStyle = .overCurrentContext
                                    vc.bookingId = statusArray[0]["Reviewpending"]["booking_id"].stringValue
                                    vc.userId = statusArray[0]["Reviewpending"]["user_id"].stringValue
                                    self.present(vc, animated: true, completion: nil)
                                }
                            }
                            else if(statusArray[0]["Finished"]["status"].stringValue == "1")
                            {
                                if(jsonResponse["booking_details"]["isProviderReviewed"].intValue == 0)
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
                                    vc.modalPresentationStyle = .overCurrentContext
                                    vc.bookingId = statusArray[0]["Finished"]["booking_id"].stringValue
                                    vc.userId = statusArray[0]["Finished"]["user_id"].stringValue
                                    self.present(vc,animated:true,completion:nil)
                                }
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
    
    
    func userDefaultAlreadyExist(kUsernameKey: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }

    
    @objc func startJobPressed(sender:UIButton!)
    {
        
        buttonTag = sender.tag
        
        
        
        if userDefaultAlreadyExist(kUsernameKey: "lastKnownLatitude")
        {
            lat = UserDefaults.standard.object(forKey:"lastKnownLatitude") as! String
            log = UserDefaults.standard.object(forKey:"lastKnownLongitude") as! String
            
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: log)
            
        }
        else
        {
        
        let alertController = UIAlertController(title: "Alert".localized(), message: "Select the option".localized(), preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Take Photo".localized(), style: .default)
        {
            (action:UIAlertAction) in
            print("You've pressed default");
            
            let picker = UIImagePickerController()
            picker.delegate = self
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: {
                action in
                
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }))
        /*    alert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .default, handler: {
                action in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }))    */
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let action2 = UIAlertAction(title: "Skip".localized(), style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
            
            self.startJob()
        }
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
            
        }

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadImage(img: image)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func uploadImage(img: UIImage){
        
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
        
        let url = "\(Constants.baseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
//        let img = self.profilePicture.image
        let imagedata = UIImageJPEGRepresentation(img, 0.6)
        
        
        
        SwiftSpinner.show("Uploading Image".localized())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    //                    print(jsonResponse)
//                    self.imageName = jsonResponse["image"].stringValue
                    self.imageString = jsonResponse["image"].stringValue
                    print(self.imageString)
                    self.startJob()
                    print("Succesfully uploaded")
//                    self.setProfile()
                    if let err = response.error{
                        self.showAlert(title: "Oops".localized(), msg: "Something went wrong".localized())
                        print(err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        })
        
    }
    
   /* func uploadImage(img: UIImage)
    {
        
        let url = "\(Constants.adminBaseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
        //        let img = self.profilePicFld.backgroundImage(for: UIControlState.normal)
        let imagedata = UIImageJPEGRepresentation(img, 1.0)
        print(imagedata)
        
        
        SwiftSpinner.show("Uploading".localized())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: nil, encodingCompletion: { (result) in
            
            switch result
            {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    print(jsonResponse)
                    self.imageString = jsonResponse["image"].stringValue
                    print(self.imageString)
                    
                    
                    self.startJob()
                    
                    print("Succesfully uploaded")
                    if let err = response.error
                    {
                        
                        SwiftSpinner.hide()

                        print(err)
                        return
                    }
                }
            case .failure(let error):
                
                
                SwiftSpinner.hide()
                
                print("Error in upload: \(error.localizedDescription)")
            }
        })
        
    }*/


    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String)
    {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        

            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {
                    
                    
                    
                    (placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks![0]

                        if pm.subLocality != nil {
                            self.addressString = self.addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            self.addressString = self.addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            self.addressString = self.addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            self.addressString = self.addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            self.addressString = self.addressString + pm.postalCode! + " "
                        }
                        
                        
                    }
                    
                    
                    
                    self.presentPOP()
            })
        

    }
    
    
    func presentPOP()
    {
        let alertController = UIAlertController(title: "Alert".localized(), message: "Select the option".localized(), preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Take Photo".localized(), style: .default)
        {
            (action:UIAlertAction) in
            print("You've pressed default");
            
            let picker = UIImagePickerController()
            picker.delegate = self
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: {
                action in
                
                picker.sourceType = .camera
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }))
      /*      alert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .default, handler: {
                action in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }))   */
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        let action2 = UIAlertAction(title: "Skip".localized(), style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
            
            self.startJob()
        }
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func startJob()
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
        
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        
        formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM

        
        let bookingId = self.bookings[buttonTag]["id"].stringValue
        print(bookingId)
      
        var booking = ""
        if SharedObject().hasData(value: bookingId){
            booking = bookingId
        }
        let params: Parameters = [
            "id": booking,
            "start_image":imageString,
            "start_lat":lat,
            "start_long":log,
            "start_address":addressString,
            "start_time":currentDateTime
        ]
        
        
        
        print("Booking params = ", params)
        
        SwiftSpinner.show("Updating your Booking Status...".localized())
//        let url = "\(Constants.baseURL)/startedjob"
        let url = APIList().getUrlString(url: .STARTJOB)
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                self.refreshControl.endRefreshing()
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("START TO CUSTOMER PLACE JSON: \(json)") // serialized json response
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
                        self.getMyBookings()
                    }
                }
            }
            else{
                self.refreshControl.endRefreshing()

                SwiftSpinner.hide()
                print(response.error.debugDescription)
                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                
            }
        }
        
    }
    
    
    @objc func cancelPressed(sender:UIButton!) {
        print("Cancel Clicked \(sender.tag)")
        
        let alert = UIAlertController(title: "Confirm".localized(), message: "Are you sure you want to cancel this booking?".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            print ("YES. CANCEL BOOKING ID :\(self.bookings[sender.tag]["booking_order_id"].stringValue)")
            let bookingId = self.bookings[sender.tag]["id"].stringValue
            print(bookingId)
            self.cancelBooking(bookingId: bookingId)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            print ("NO.DONT CANCEL BOOKING ID :\(self.bookings[sender.tag]["booking_order_id"].stringValue)")
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
    }
    
    func getMyBookings()
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
        print("params = \(headers!)")
        SwiftSpinner.show("Fetching your Bookings...".localized())
//        let url = "\(Constants.baseURL)/homedashboard"
        let url = APIList().getUrlString(url: .HOMEDASHBOARD)
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                self.refreshControl.endRefreshing()
                SwiftSpinner.hide()
                
                if let json = response.result.value {
                    print("BOOKINGS JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    print(jsonResponse)
                    let errormsg = jsonResponse["Accepted"].arrayValue
                    let pending = jsonResponse["Pending"].arrayValue
                    let recpending = jsonResponse["RecurralPending"].arrayValue
                    if errormsg.count == 0
                    {
                        if pending.count == 0
                        {
                            if recpending.count == 0
                            {
                                self.vwtop.isHidden = false
                            }
                            else
                            {
                                self.vwtop.isHidden = true
                            }
                        }
                        else
                        {
                            self.vwtop.isHidden = true
                        }
                    }
                    else
                    {
                        self.vwtop.isHidden = true
                    }
                    
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
                        self.bookings.removeAll()
                        self.bookings = jsonResponse["Accepted"].arrayValue
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                        self.appSettings()
                        if(jsonResponse["random_request_pending"].arrayValue.count > 0)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRequestViewController") as!                            NewRequestViewController
                            
                            vc.bookingDetail = jsonResponse["random_request_pending"][0].dictionaryValue
                            let image = jsonResponse["provider_details"]["image"].string
                            UserDefaults.standard.set(image, forKey: "image")
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            vc.bookingRequestType = "random"
                            self.present(vc, animated: false, completion: nil)
                        }
                        else if(jsonResponse["RecurralPending"].arrayValue.count > 0)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRequestViewController") as!                            NewRequestViewController
                            
                            vc.bookingDetail = jsonResponse["RecurralPending"][0].dictionaryValue
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            vc.bookingRequestType = "recurral"
                            self.present(vc, animated: false, completion: nil)
                        }
                        else if(jsonResponse["Pending"].arrayValue.count > 0)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewRequestViewController") as!                            NewRequestViewController
                            
                            vc.bookingDetail = jsonResponse["Pending"][0].dictionaryValue
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.bookingRequestType = "normal"
                            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                            self.present(vc, animated: false, completion: nil)
                        }
                    }
                }
            }
            else{
                self.refreshControl.endRefreshing()

                SwiftSpinner.hide()
                print(response.error.debugDescription)
                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                
            }
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
    
    func cancelBooking(bookingId: String)
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
        
        print(bookingId)
        var booking = ""
        if SharedObject().hasData(value: bookingId)
        {
            booking = bookingId
        }
        
        let params: Parameters = [
            "id": booking
        ]
        
        SwiftSpinner.show("Cancelling your Booking...".localized())
        let url = APIList().getUrlString(url: .CANCEL_BY_PROVIDER)
//        let url = "\(Constants.baseURL)/cancelbyprovider"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                self.refreshControl.endRefreshing()
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
                        self.getMyBookings()
                    }
                }
            }
            else{
                self.refreshControl.endRefreshing()

                SwiftSpinner.hide()
                print(response.error.debugDescription)
                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTableViewCell", for: indexPath) as! BookingTableViewCell
        cell.providerName.text = self.bookings[indexPath.row]["Name"].stringValue
        cell.subCategoryName.text = self.bookings[indexPath.row]["sub_category_name"].stringValue
        cell.serviceDate.text = self.bookings[indexPath.row]["booking_date"].stringValue
         cell.serviceTime.text = self.bookings[indexPath.row]["timing"].stringValue
        if let imageURL = URL.init(string:self.bookings[indexPath.row]["userimage"].stringValue)
        {
            Nuke.loadImage(with: imageURL, into: cell.providerImage)
        }
        else {
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                //            var color: UIColor? = nil
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                changeTintColor(cell.providerImage, arg: mycolor)
            }
        }
        let status = self.bookings[indexPath.row]["status"].stringValue
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.changeStatusButton.tag = indexPath.row
        
        if #available(iOS 11.0, *) {
            cell.cornerView.clipsToBounds = true
            cell.cornerView.layer.cornerRadius = 10
            
            cell.cornerView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
            cell.cornerView.clipsToBounds = true
            let maskPath = UIBezierPath(roundedRect: cell.cornerView.bounds,
                                        byRoundingCorners: [.bottomRight],
                                        cornerRadii: CGSize(width: 10.0, height: 10.0))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            cell.cornerView.layer.mask = shape
            
        }
        
        if(status == "Pending")
        {
            //--
            cell.bookingStatusImageView.image = UIImage(named: "pending_red")
            cell.bookingStatusLbl.text = "Pending".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            
            cell.cornerView.isHidden = true
            cell.changeStatusButton.isHidden = true
            cell.changeStatusButton.isUserInteractionEnabled = false
            
            //--
            
        }
        else if(status == "Rejected")
        {
            //--
            cell.bookingStatusImageView.image = UIImage(named: "new_cancelled")
            cell.bookingStatusLbl.text = "Rejected".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            
            cell.cornerView.isHidden = true
            
        }
        else if(status == "Accepted")
        {
            
            //--
            cell.bookingStatusImageView.image = UIImage(named: "finished_green")
            cell.bookingStatusLbl.text = "Accepted".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            
            cell.cornerView.isHidden = false
            cell.cornerView.backgroundColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
//            cell.changeStatusButton.tag = 1
            cell.changeStatusLbl.text = "START TO PLACE".localized()
            cell.changeStatusButton.addTarget(self, action: #selector(self.changeStatus(sender:)), for: .touchUpInside)
            
            //--
            
        }
        else if(status == "CancelledbyUser")
        {
            
            //--
            cell.bookingStatusImageView.image = UIImage(named: "new_cancelled")
            cell.bookingStatusLbl.text = "Cancelled by User".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            
            cell.cornerView.isHidden = true
            //--
            
        }
        else if(status == "CancelledbyProvider")
        {
            //--
            cell.bookingStatusImageView.image = UIImage(named: "new_cancelled")
            cell.bookingStatusLbl.text = "Cancelled by Provider".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            
            cell.cornerView.isHidden = true
            
            //==
           
        }
        else if(status == "StarttoCustomerPlace")
        {
            //--
            cell.bookingStatusImageView.image = UIImage(named: "start_to_place")
            cell.bookingStatusLbl.text = "On the way".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            
            cell.cornerView.isHidden = false
            cell.changeStatusLbl.text = "START JOB".localized()
            
            cell.cornerView.backgroundColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            
            cell.changeStatusButton.addTarget(self, action: #selector(self.changeStatus(sender:)), for: .touchUpInside)

//            cell.changeStatusButton.tag = 2
            //--
           
            
        }
        else if(status == "Startedjob")
        {
            
            //--
            cell.bookingStatusImageView.image = UIImage(named: "start_job")
            cell.bookingStatusLbl.text = "Work in progress".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            
            
            
            cell.cornerView.isHidden = true
            //--
            

            
            
        }
        else if(status == "Completedjob")
        {
            
            //--
            cell.bookingStatusImageView.image = UIImage(named: "pay")
            cell.bookingStatusLbl.text = "Payment pending".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            
            cell.cornerView.isHidden = true
            //--
            
          
            
        }
        else if(status == "Waitingforpaymentconfirmation")
        {
            print(status)
            //--
            cell.bookingStatusImageView.image = UIImage(named: "pay")
            cell.bookingStatusLbl.text = "Payment pending".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            
            cell.cornerView.isHidden = true
            //--

        }
        else if(status == "Reviewpending")
        {
            cell.bookingStatusImageView.image = UIImage(named: "new_finished")
            cell.bookingStatusLbl.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            cell.cornerView.isHidden = true

            if(self.bookings[indexPath.row]["isProviderReviewed"].intValue == 0)
            {
                cell.bookingStatusLbl.text = "Review pending".localized()
            }
            else{
                cell.bookingStatusLbl.text = "Job Completed".localized()
            }
            //==-

        }
        else if(status == "Finished")
        {
            //--
            cell.bookingStatusImageView.image = UIImage(named: "new_finished")
            cell.bookingStatusLbl.text = "Job Completed".localized()
            cell.bookingStatusLbl.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            
            cell.cornerView.isHidden = true
            //--
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stoaryboard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
        let vc = stoaryboard.instantiateViewController(withIdentifier: "BookingDetailsViewController")as! BookingDetailsViewController
        MainViewController.changePage = false
        vc.bookingDetails = self.bookings[indexPath.row].dictionary
        vc.cancledelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookings.count
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        
        let userInfo = notification.request.content.userInfo
        
        
        
        
        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
        
        print("dct = ",dct)
        
        
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let receiver_id = dct.object(forKey: "sender_id") as! String
                
                if appDelegate.chatReceiveID == ""
                {
                    completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
                }
                else
                {
                    
                    
                }
                
            }
            else
            {
                appSettings()
                getMyBookings()
                completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
               
            }
        }
        else
        {
            appSettings()
            getMyBookings()
            completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(UInt8(UNNotificationPresentationOptions.alert.rawValue) | UInt8(UNNotificationPresentationOptions.sound.rawValue))))
            
            
            
        }
        
        
        
        
        
        
        
    }
    
}

