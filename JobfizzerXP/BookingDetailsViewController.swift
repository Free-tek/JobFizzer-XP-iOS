//  BookingDetailsViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Nuke
import UserNotifications
import GoogleMaps
import GooglePlaces
import Floaty

protocol cancelproviderdele
{
    func cancel()  
}

class BookingDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    var bookingDetails : [String:JSON]!
    
    @IBOutlet weak var floatingView: UIView!
    
    let sharedInstance = Connection()
    
    var h = 0
    var m = 0
    var s = 0
    var d = 0
    
    var time = 0
    
    var updateElapsedTimes : String = ""
    var cancledelegate : cancelproviderdele!
    @IBOutlet weak var imggps: UIImageView!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var directionImg: UIImageView!
    @IBOutlet weak var directionsButton: UIButton!
    var timer : Timer!
    @IBOutlet weak var bookingStatus: UILabel!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var serviceStatusTableConstraintConstant: NSLayoutConstraint!

    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var imgchat: UIImageView!
    @IBOutlet weak var imgbilling: UIImageView!
    @IBOutlet weak var workingHours: UILabel!
    @IBOutlet weak var bookingAddress: UILabel!
    @IBOutlet weak var bookingTime: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
    @IBOutlet weak var bookingId: UILabel!
    @IBOutlet weak var bookingName: UILabel!
    @IBOutlet weak var subCategoryName: UILabel!
    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var lblElapsedTime: UILabel!
    
    @IBOutlet weak var imgclock: UIImageView!
    @IBOutlet weak var elapsedTimeLblvwHeight: NSLayoutConstraint!
    @IBOutlet weak var elapsedTimeView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var hourDigit1: UILabel!
    @IBOutlet weak var hourDigit2: UILabel!
    @IBOutlet weak var minuteDigit1: UILabel!
    @IBOutlet weak var minuteDigit2: UILabel!
    @IBOutlet weak var secondsDigit1: UILabel!
    @IBOutlet weak var secondsDigit2: UILabel!
    
    @IBOutlet weak var elapsedTimeLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    
    @IBOutlet weak var vwchat: UIView!
    
    @IBOutlet weak var cancelLbl: UILabel!
    
    var lat = ""
    var log = ""
    
    
    var addressString : String = ""
    
    var buttonTag = 0
    
    var imageString = " "
    
    @IBOutlet weak var bookIDLBl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var addLbl: UILabel!
    
    var h1: String = ""
    var h2: String = ""
    var m1: String = ""
    var m2: String = ""
    var sec1: String = ""
    var sec2: String = ""

    @IBOutlet weak var serviceStateLbl: UILabel!
    
    @IBOutlet weak var hrLbl: UILabel!
    @IBOutlet weak var minsLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var totLbl: UILabel!
    
    @IBOutlet weak var bookingStatysLbl: UILabel!
    @IBOutlet weak var bookingNmeLbl: UILabel!
    
    var statusArray : [String] = []
    var timeStampArray : [String] = []
    var mycolor = UIColor()
    
    @IBOutlet weak var serviceStatusTableView: UITableView!

    func layoutFAB()
    {
        let floaty = Floaty()
        floaty.hasShadow = false
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            floaty.buttonColor = mycolor
            floaty.itemButtonColor = mycolor
        }
        floaty.addItem("Cancel", icon: UIImage(named: "new_cancelled"))
        {
            item in
            
            let bookingId = self.bookingDetails["booking_order_id"]!.stringValue
            let alert = UIAlertController(title: "Confirm".localized(), message: "Are you sure you want to cancel this booking?".localized(), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in
                print ("YES. CANCEL BOOKING ID :\(bookingId)")
                let bookingId = self.bookingDetails["id"]?.stringValue
                print(bookingId)
                self.cancelBooking(bookingId: bookingId!)
            }))
            
            
            alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in
                print ("NO.DONT CANCEL BOOKING ID :\(bookingId)")
            }))
            
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        floaty.addItem("Chat", icon: UIImage(named: "chat (1)"))
        {
            item in
            let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dvc = stoaryboard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            print("id = \(self.bookingDetails["user_id"]!.stringValue)")
            dvc.receiverId = self.bookingDetails["user_id"]!.stringValue
            dvc.bookingId = self.bookingDetails["id"]!.stringValue
            self.view.willRemoveSubview(floaty)
            dvc.modalTransitionStyle = .crossDissolve
            self.present(dvc, animated: true, completion: nil)
        }
        
        //        floaty.addItem("Bill", icon: UIImage(named: "payment"))
        floaty.paddingX = self.floatingView.frame.width/1.5 - floaty.frame.width/2
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
    }
    
    func chatlayoutFAB()
    {
        let floaty = Floaty()
        floaty.hasShadow = false
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            floaty.buttonColor = mycolor
            floaty.itemButtonColor = mycolor
        }
        floaty.addItem("Chat", icon: UIImage(named: "chat (1)"))
        {
            item in
            let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dvc = stoaryboard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            dvc.receiverId = self.bookingDetails["user_id"]!.stringValue
            dvc.bookingId = self.bookingDetails["id"]!.stringValue
            dvc.modalTransitionStyle = .crossDissolve
            self.view.willRemoveSubview(floaty)
            self.present(dvc, animated: true, completion: nil)
        }
        floaty.paddingX = self.floatingView.frame.width/1.5 - floaty.frame.width/2
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
    }
    
    func cancellayoutFAB()
    {
        let floaty = Floaty()
        floaty.hasShadow = false
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            floaty.buttonColor = mycolor
            floaty.itemButtonColor = mycolor
        }
        floaty.addItem("Chat", icon: UIImage(named: "chat (1)"))
        {
            item in
            let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dvc = stoaryboard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            dvc.receiverId = self.bookingDetails["user_id"]!.stringValue
            dvc.bookingId = self.bookingDetails["id"]!.stringValue
            dvc.modalTransitionStyle = .crossDissolve
             self.view.willRemoveSubview(floaty)
            self.present(dvc, animated: true, completion: nil)
        }
        floaty.addItem("Track", icon: UIImage(named: "Directions"))
        {
            item in
            let latitude = self.bookingDetails["user_latitude"]!.stringValue
            let longitude = self.bookingDetails["user_longitude"]!.stringValue
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
            self.view.willRemoveSubview(floaty)
        }
        //        floaty.addItem("Bill", icon: UIImage(named: "payment"))
        floaty.paddingX = self.floatingView.frame.width/1.5 - floaty.frame.width/2
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
    }
    func NavigationlayoutFAB()
    {
        let floaty = Floaty()
        floaty.hasShadow = false
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            floaty.buttonColor = mycolor
            floaty.itemButtonColor = mycolor
        }
        floaty.backgroundColor = UIColor.red
        floaty.addItem("Chat", icon: UIImage(named: "chat "))
        {
            item in
            let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dvc = stoaryboard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
            dvc.receiverId = self.bookingDetails["user_id"]!.stringValue
            dvc.bookingId = self.bookingDetails["id"]!.stringValue
            dvc.modalTransitionStyle = .crossDissolve
            self.view.willRemoveSubview(floaty)
            self.present(dvc, animated: true, completion: nil)
        }
        //        floaty.addItem("Bill", icon: UIImage(named: "payment"))
        floaty.paddingX = self.floatingView.frame.width/1.5 - floaty.frame.width/2
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hrLbl.text = "hr".localized()
        minsLbl.text = "min".localized()
        elapsedTimeLbl.text = "Elapsed Time".localized()
        hoursLbl.text = "Hours".localized()
        taxLbl.text = "TAX".localized()
        totLbl.text = "Total".localized()
        bookingStatysLbl.text = "Booking Status".localized()
        bookingNmeLbl.text = "Booking Name".localized()
        bookIDLBl.text = "Booking ID".localized()
        dateLbl.text = "Date and Time".localized()
        addLbl.text = "Address".localized()
        button.setTitle("Finish Job".localized(), for: .normal)
        serviceStateLbl.text = "Service Status".localized()
        cancelLbl.text = "CANCEL".localized()
        
        subCategoryName.font = FontBook.Medium.of(size: 20)
        hrLbl.font = FontBook.Regular.of(size: 13)
        minsLbl.font = FontBook.Regular.of(size: 13)
        elapsedTimeLbl.font = FontBook.Medium.of(size: 16)
        hoursLbl.font = FontBook.Medium.of(size: 17)
        taxLbl.font = FontBook.Medium.of(size: 17)
        totLbl.font = FontBook.Medium.of(size: 17)
        workingHours.font = FontBook.Regular.of(size: 16)
        tax.font = FontBook.Regular.of(size: 16)
        total.font = FontBook.Regular.of(size: 16)
        bookingStatysLbl.font = FontBook.Medium.of(size: 17)
        bookingStatus.font = FontBook.Medium.of(size: 16)
        bookingNmeLbl.font = FontBook.Medium.of(size: 17)
        bookingName.font = FontBook.Medium.of(size: 17)
        bookIDLBl.font = FontBook.Medium.of(size: 17)
        dateLbl.font = FontBook.Medium.of(size: 17)
        addLbl.font = FontBook.Medium.of(size: 17)
        button.titleLabel!.font = FontBook.Medium.of(size: 17)
        serviceStateLbl.font = FontBook.Medium.of(size: 17)
        bookingId.font = FontBook.Medium.of(size: 16)
        bookingDate.font = FontBook.Medium.of(size: 16)
        bookingTime.font = FontBook.Medium.of(size: 16)
        bookingAddress.font = FontBook.Medium.of(size: 16)
        cancelLbl.font = FontBook.Regular.of(size: 13)
        
        hourDigit1.text = ""
        hourDigit2.text = ""
        
        minuteDigit1.text = ""
        minuteDigit2.text = ""
        
        secondsDigit1.text = ""
        secondsDigit2.text =  ""
        
        imgclock.isHidden = true
        print("bookingDetails = ",bookingDetails)
        serviceStatusTableView.delegate = self
        serviceStatusTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            button.backgroundColor = mycolor
            hourDigit1.backgroundColor = mycolor
            hourDigit2.backgroundColor = mycolor
            minuteDigit1.backgroundColor = mycolor
            minuteDigit2.backgroundColor = mycolor
            secondsDigit1.backgroundColor = mycolor
            secondsDigit2.backgroundColor = mycolor
            changeTintColor(imggps, arg: mycolor)
            workingHours.textColor = mycolor
            //            bookingStatus.textColor = mycolor
            total.textColor = mycolor
            changeTintColor(imgbilling, arg: mycolor)
            changeTintColor(imgchat, arg: mycolor)
            changeTintColor(imgclock, arg: mycolor)
            //changeTintColor(directionImg, arg: mycolor)
            //directionImg.image = directionImg.image?.withRenderingMode(.alwaysTemplate)
            directionImg.tintColor = mycolor
            directionImg.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        lblElapsedTime.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
        let lat = self.bookingDetails["user_latitude"]!.doubleValue
        let long = self.bookingDetails["user_longitude"]!.doubleValue
        
        let styleMapUrl: String = "https://maps.googleapis.com/maps/api/staticmap?sensor=false&size=\(2 * Int(self.mapImage.frame.size.width))x\(2 * Int(self.mapImage.frame.size.height))&zoom=15&center=\(lat),\(long)&style=feature:administrative%7Celement:geometry%7Ccolor:0x1d1d1d%7Cweight:1&style=feature:administrative%7Celement:labels.text.fill%7Ccolor:0x93a6b5&style=feature:landscape%7Ccolor:0xeff0f5&style=feature:landscape%7Celement:geometry%7Ccolor:0xdde3e3%7Cvisibility:simplified%7Cweight:0.5&style=feature:landscape%7Celement:labels%7Ccolor:0x1d1d1d%7Cvisibility:simplified%7Cweight:0.5&style=feature:landscape.natural.landcover%7Celement:geometry%7Ccolor:0xfceff9&style=feature:poi%7Celement:geometry%7Ccolor:0xeeeeee&style=feature:poi%7Celement:labels%7Cvisibility:off%7Cweight:0.5&style=feature:poi%7Celement:labels.text%7Ccolor:0x505050%7Cvisibility:off&style=feature:poi.attraction%7Celement:labels%7Cvisibility:off&style=feature:poi.attraction%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:off&style=feature:poi.business%7Celement:labels%7Cvisibility:off&style=feature:poi.business%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:off&style=feature:poi.government%7Celement:labels%7Cvisibility:off&style=feature:poi.government%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:off&style=feature:poi.medical%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:simplified&style=feature:poi.park%7Celement:geometry%7Ccolor:0xa9de82&style=feature:poi.park%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:simplified&style=feature:poi.place_of_worship%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:simplified&style=feature:poi.school%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:simplified&style=feature:poi.sports_complex%7Celement:labels.text%7Ccolor:0xa6a6a6%7Cvisibility:simplified&style=feature:road%7Celement:geometry%7Ccolor:0xffffff&style=feature:road%7Celement:labels.text%7Ccolor:0xc0c0c0%7Cvisibility:simplified%7Cweight:0.5&style=feature:road%7Celement:labels.text.fill%7Ccolor:0x000000&style=feature:road.highway%7Celement:geometry%7Ccolor:0xf4f4f4%7Cvisibility:simplified&style=feature:road.highway%7Celement:labels.text%7Ccolor:0x1d1d1d%7Cvisibility:simplified&style=feature:road.highway.controlled_access%7Celement:geometry%7Ccolor:0xf4f4f4&style=feature:transit%7Celement:geometry%7Ccolor:0xc0c0c0&style=feature:water%7Celement:geometry%7Ccolor:0xa5c9e1&key=\(Constants.mapsKey)"//"https://maps.googleapis.com/maps/api/staticmap?key=AIzaSyDcuEgb-Jr0-QKM6SdFd3WxCPhEeukUHtM&center=\(lat),\(long)&zoom=15&format=jpeg&maptype=roadmap&size=\(2 * Int(self.mapImage.frame.size.width))x\(2 * Int(self.mapImage.frame.size.height))&sensor=true""https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(long)&destination=\(lat),\(destination.longitude)&sensor=false&mode=driving&key=\(Constants.mapsKey)" //
        
        statusArray.removeAll()
        timeStampArray.removeAll()
        
        switch bookingDetails["status"]!.stringValue {
        case "Completedjob":
            bookingStatus.text = "Payment pending".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            directionImg.isHidden = true
            directionsButton.isHidden = true
//            self.view.willRemoveSubview(floaty)
            imgclock.isHidden = true
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            statusArray.append("Provider Started Job")
            statusArray.append("Provider Completed Job")
            
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            timeStampArray.append(bookingDetails["startjob_timestamp"]!.stringValue)
            timeStampArray.append(bookingDetails["endjob_timestamp"]!.stringValue)
            
        case "Waitingforpaymentconfirmation":
            bookingStatus.text = "Payment pending".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            statusArray.append("Provider Started Job")
            statusArray.append("Provider Completed Job")
            imgclock.isHidden = true
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            timeStampArray.append(bookingDetails["startjob_timestamp"]!.stringValue)
            timeStampArray.append(bookingDetails["endjob_timestamp"]!.stringValue)
            
        case "Reviewpending":
            bookingStatus.text = "Review pending".localized()
            bookingStatus.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            statusArray.append("Provider Started Job")
            statusArray.append("Provider Completed Job")
            imgclock.isHidden = true
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            timeStampArray.append(bookingDetails["startjob_timestamp"]!.stringValue)
            timeStampArray.append(bookingDetails["endjob_timestamp"]!.stringValue)
            
        case "Finished":
            bookingStatus.text = "Job Completed".localized()
            bookingStatus.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            statusArray.append("Provider Started Job")
            statusArray.append("Provider Completed Job")
            imgclock.isHidden = true
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            timeStampArray.append(bookingDetails["startjob_timestamp"]!.stringValue)
            timeStampArray.append(bookingDetails["endjob_timestamp"]!.stringValue)
        case "StarttoCustomerPlace":
            bookingStatus.text = "On the way".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            directionImg.isHidden = false
            directionsButton.isHidden = false
//            self.view.willRemoveSubview(floaty)
            cancellayoutFAB()
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            imgclock.isHidden = true
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            
        case "Startedjob":
            bookingStatus.text = "Work in progress".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.31, blue:0.13, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            directionImg.isHidden = true
            directionsButton.isHidden = true
            chatlayoutFAB()
            imgclock.isHidden = false
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            statusArray.append("Provider Started to Place")
            statusArray.append("Provider Started Job")
            
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            timeStampArray.append(bookingDetails["StarttoCustomerPlace_time"]!.stringValue)
            timeStampArray.append(bookingDetails["startjob_timestamp"]!.stringValue)
        case "Pending":
            bookingStatus.text = "Pending".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            imgclock.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            
        case "Accepted":
            bookingStatus.text = "Accepted".localized()
            bookingStatus.textColor = UIColor(red:0.10, green:0.77, blue:0.49, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            imgclock.isHidden = true
            directionImg.isHidden = false
            directionsButton.isHidden = false
//            self.view.willRemoveSubview(floaty)
            cancellayoutFAB()
            statusArray.append("Service Requested")
            statusArray.append("Service Accepted")
            
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Accepted_time"]!.stringValue)
            
        case "Rejected":
            bookingStatus.text = "Rejected".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            imgclock.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Rejected")
            
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["Rejected_time"]!.stringValue)
            
        case "CancelledbyProvider":
            bookingStatus.text = "Cancelled by Provider".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Cancelled by Provider")
            imgclock.isHidden = true
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["CancelledbyProvider_time"]!.stringValue)
        case "CancelledbyUser":
            bookingStatus.text = "Cancelled by User".localized()
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            cancelView.isHidden = true
            vwchat.isHidden = true
            imgclock.isHidden = true
//            self.view.willRemoveSubview(floaty)
            statusArray.append("Service Requested")
            statusArray.append("Service Cancelled by User")
            
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
            timeStampArray.append(bookingDetails["CancelledbyUser_time"]!.stringValue)
        default:
            bookingStatus.text = "Pending".localized()
            cancelView.isHidden = true
            vwchat.isHidden = true
            imgclock.isHidden = true
//            self.view.willRemoveSubview(floaty)
            bookingStatus.textColor = UIColor(red:0.89, green:0.13, blue:0.19, alpha:1.0)
            statusArray.append("Service Requested")
            timeStampArray.append(bookingDetails["Pending_time"]!.stringValue)
        }
        
        print(styleMapUrl)
        if let url = URL(string: styleMapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        {
            Nuke.loadImage(with: url, into: self.mapImage)
        }
        
        // Do any additional setup after loading the view.
        if(bookingDetails["status"]?.stringValue == "Completedjob" || bookingDetails["status"]?.stringValue == "Waitingforpaymentconfirmation" ||
            bookingDetails["status"]?.stringValue == "Reviewpending" ||
            bookingDetails["status"]?.stringValue == "Finished")
        {
            self.workingHours.isHidden = false
            self.taxLbl.isHidden = false
            self.tax.isHidden = false
            self.total.isHidden = false
            self.button.isHidden = true
            
            self.elapsedTimeView.isHidden = true
            vwchat.isHidden = true
            self.total.text = "₦\(bookingDetails["total_cost"]!.stringValue)"
            self.tax.text = bookingDetails["gst_cost"]!.stringValue
            self.taxLbl.text = "\(bookingDetails["tax_name"]!.stringValue) (\(bookingDetails["gst_percent"]!.stringValue)%)"
            
            
            let workhrs = minutesToHoursMinutes(minutes: bookingDetails["worked_mins"]!.intValue)
            
            
            let mins = "mins".localized()
            let Hr = "Hr".localized()
            
            if(workhrs.hours > 0){
                self.workingHours.text = "\(workhrs.hours) \(Hr) & \(workhrs.leftMinutes) \(mins)"
            }
            else{
                self.workingHours.text = "\(workhrs.leftMinutes) \(mins)"
            }
            
            self.elapsedTimeView.isHidden = true
            //            self.workingHours.text = bookingDetails["worked_mins"]!.stringValue
            self.bookingAddress.text = bookingDetails["address_line_1"]!.stringValue
            self.bookingTime.text = bookingDetails["timing"]!.stringValue
            self.bookingDate.text = bookingDetails["booking_date"]!.stringValue
            self.bookingId.text = bookingDetails["booking_order_id"]!.stringValue
            self.bookingName.text = bookingDetails["Name"]!.stringValue
            self.subCategoryName.text = bookingDetails["sub_category_name"]!.stringValue
            
        }
        else if(bookingDetails["status"]?.stringValue == "StarttoCustomerPlace" || bookingDetails["status"]?.stringValue == "Startedjob"){
            self.workingHours.isHidden = true
            self.taxLbl.isHidden = true
            self.tax.isHidden = true
            self.total.isHidden = true
            
            vwchat.isHidden = true
            
            self.button.isHidden = false
            priceViewHeightConstraint.constant = 0
            priceView.layoutIfNeeded()
            scrollView.layoutIfNeeded()
            vwchat.isHidden = true
            if(bookingDetails["status"]?.stringValue == "Startedjob")
            {
                self.updateElapsedTime()

                self.elapsedTimeView.isHidden = false
                self.button.isHidden = false
            }
            else{
                
                self.elapsedTimeView.isHidden = true
                self.button.isHidden = true
            }
            
            self.bookingAddress.text = bookingDetails["address_line_1"]!.stringValue
            self.bookingTime.text = bookingDetails["timing"]!.stringValue
            self.bookingDate.text = bookingDetails["booking_date"]!.stringValue
            self.bookingId.text = bookingDetails["booking_order_id"]!.stringValue
            self.bookingName.text = bookingDetails["Name"]!.stringValue
            self.subCategoryName.text = bookingDetails["sub_category_name"]!.stringValue
        }
        else{
            self.button.isHidden = true
            priceViewHeightConstraint.constant = 0
            priceView.layoutIfNeeded()
            scrollView.layoutIfNeeded()
            self.elapsedTimeView.isHidden = true
            vwchat.isHidden = true
            self.bookingAddress.text = bookingDetails["address_line_1"]!.stringValue
            self.bookingTime.text = bookingDetails["timing"]!.stringValue
            self.bookingDate.text = bookingDetails["booking_date"]!.stringValue
            self.bookingId.text = bookingDetails["booking_order_id"]!.stringValue
            self.bookingName.text = bookingDetails["Name"]!.stringValue
            self.subCategoryName.text = bookingDetails["sub_category_name"]!.stringValue
        }
        
        let serviceStatusTableViewHeight = 75 * statusArray.count
        serviceStatusTableView.rowHeight = UITableViewAutomaticDimension
        serviceStatusTableView.estimatedRowHeight = 75
        
        
        serviceStatusTableView.frame = CGRect.init(x: serviceStatusTableView.frame.origin.x, y: serviceStatusTableView.frame.origin.y, width: serviceStatusTableView.frame.size.width, height: CGFloat(serviceStatusTableViewHeight))
        serviceStatusTableConstraintConstant.constant = CGFloat(serviceStatusTableViewHeight)
        serviceStatusTableView.reloadData()
        serviceStatusTableView.layoutIfNeeded()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        
        sharedInstance.bookingID = bookingDetails["id"]!.stringValue
        
        
        
        if(bookingDetails["status"]?.stringValue == "Startedjob")
        {
            //            self.updateElapsedTime()
            
            self.getElapseData()
            
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BookingDetailsViewController.updateElapsedTime), userInfo: nil, repeats: true)
        }
    }
/*    {
        if(bookingDetails["status"]?.stringValue == "Startedjob")
        {
//            self.updateElapsedTime()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(BookingDetailsViewController.updateElapsedTime), userInfo: nil, repeats: true)
        }
    }*/
    
    
    
    /*
    @objc func updateElapsedTime(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        print("Current TIME: \(formatter.string(from: Date()))")
        let currentTime = formatter.string(from: Date())
        
        let dateString = bookingDetails["job_start_time"]!.stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        
        
        let currentDateObj = dateFormatter.date(from: currentTime)!
        let dateObj = dateFormatter.date(from: dateString)!
        
        let difference = currentDateObj.offsetFrom(date: dateObj)
        if(difference.hours > 9){
            let split = splitIntoTwoDigits(input: difference.hours)
            hourDigit1.text = String(describing: split.firstDigit)
            hourDigit2.text = String(describing: split.secondDigit)
        }
        else{
            hourDigit1.text = "0"
            hourDigit2.text = String(describing: difference.hours)
        }
        
        if(difference.minutes > 9){
            let split = splitIntoTwoDigits(input: difference.minutes)
            minuteDigit1.text = String(describing: split.firstDigit)
            minuteDigit2.text = String(describing: split.secondDigit)
        }
        else{
            minuteDigit1.text = "0"
            minuteDigit2.text = String(describing: difference.minutes)
        }
        
        if(difference.seconds > 9){
            let split = splitIntoTwoDigits(input: difference.seconds)
            secondsDigit1.text = String(describing: split.firstDigit)
            secondsDigit2.text =  String(describing: split.secondDigit)
        }
        else{
            secondsDigit1.text = "0"
            secondsDigit2.text = String(describing: difference.seconds)
        }
    }*/
    
    
    
    @objc func updateElapsedTime()
    {
    
        let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: self.time)
        
        if(h > 9){
            let split = splitIntoTwoDigits(input:h)
//            hourDigit1.text = String(describing: split.firstDigit)
//            hourDigit2.text = String(describing: split.secondDigit)
            h1 = String(describing: split.firstDigit)
            h2 = String(describing: split.secondDigit)
        }
        else{
//            hourDigit1.text = "0"
//            hourDigit2.text = String(describing: h)
            h1 = "0"
            h2 = String(describing: h)
        }
        
        if(m > 9){
            let split = splitIntoTwoDigits(input: m)
//            minuteDigit1.text = String(describing: split.firstDigit)
//            minuteDigit2.text = String(describing: split.secondDigit)
            m1 = String(describing: split.firstDigit)
            m2 = String(describing: split.secondDigit)
        }
        else{
//            minuteDigit1.text = "0"
//            minuteDigit2.text = String(describing: m)
            m1 = "0"
            m2 = String(describing: m)
        }
        
        if(s > 9){
            let split = splitIntoTwoDigits(input: s)
//            secondsDigit1.text = String(describing: split.firstDigit)
//            secondsDigit2.text =  String(describing: split.secondDigit)
            sec1 = String(describing: split.firstDigit)
            sec2 =  String(describing: split.secondDigit)
        }
        else{
//            secondsDigit1.text = "0"
//            secondsDigit2.text = String(describing: s)
            sec1 = "0"
            sec2 = String(describing: s)
        }
        lblElapsedTime.text = "\(h1)\(h2):\(m1)\(m2):\(sec1)\(sec2)"
        self.time = self.time + 1
        
        /*
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm:ss"
         //        print("Current TIME: \(formatter.string(from: Date()))")
         let currentTime = formatter.string(from: Date())
         
         //        let dateString = bookingDetails["job_start_time"]!.stringValue
         
         let dateString = self.updateElapsedTimes
         
         print("Date String = ",dateString)
         
         
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
         dateFormatter.locale = Locale.init(identifier: "en_GB")
         
         
         
         //        let currentDateObj = dateFormatter.date(from: currentTime)!
         let dateObj = dateFormatter.date(from: dateString)!
         
         //        let difference = currentDateObj.offsetFrom(date: dateObj)
         
         
         
         let calendar = Calendar.current
         let difference = calendar.dateComponents([.hour,.minute,.second], from: dateObj)
         
         
         //        let difference = dateObj
         
         if(difference.hour! > 9){
         let split = splitIntoTwoDigits(input: difference.hour!)
         hourDigit1.text = String(describing: split.firstDigit)
         hourDigit2.text = String(describing: split.secondDigit)
         }
         else{
         hourDigit1.text = "0"
         hourDigit2.text = String(describing: difference.hour)
         }
         
         if(difference.minute! > 9){
         let split = splitIntoTwoDigits(input: difference.minute!)
         minuteDigit1.text = String(describing: split.firstDigit)
         minuteDigit2.text = String(describing: split.secondDigit)
         }
         else{
         minuteDigit1.text = "0"
         minuteDigit2.text = String(describing: difference.minute)
         }
         
         if(difference.second! > 9){
         let split = splitIntoTwoDigits(input: difference.second!)
         secondsDigit1.text = String(describing: split.firstDigit)
         secondsDigit2.text =  String(describing: split.secondDigit)
         }
         else{
         secondsDigit1.text = "0"
         secondsDigit2.text = String(describing: difference.second)
         }*/
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if(timer != nil)
        {
            timer.invalidate()
        }
      
    }
    
    
    func getElapseData()
    {
        sharedInstance.postConnection("elapsetime", success:
            {
                (json) in
                
                SwiftSpinner.hide()
                print("Elapsetime Json = ",json)
                let jsonResponse = JSON(json)
                
                if(jsonResponse["error"].stringValue == "false")
                {
                    let data = jsonResponse["data"].dictionaryValue
                    self.d = (data["d"]?.intValue)!
                    self.m = (data["i"]?.intValue)!
                    self.h = (data["h"]?.intValue)!
                    self.s = (data["s"]?.intValue)!
                    let day = (data["days"]?.intValue)!
                    
//                    self.time = self.d * 24 + self.h * 60 * 60 + self.m * 60 + self.s + (day * 24 * 60 * 60 * 60)
                    
                    self.time = self.h * 60 * 60 + self.m * 60 + self.s +  (day * 24 * 60 * 60)

                    print("Time = \(self.time)")
                    /*
                     
                     let dateFormatterGet = DateFormatter()
                     dateFormatterGet.dateFormat = "HH:mm:ss"
                     
                     //                    let dateFormatterPrint = DateFormatter()
                     //                    dateFormatterPrint.dateFormat = "MMM dd,yyyy"
                     
                     let string = "\(self.h) : \(self.m) : \(self.s)"
                     
                     if let date = dateFormatterGet.date(from: string)
                     {
                     print("Current Date = ",date)
                     }*/
                    
                    self.updateElapsedTime()
                }
                
        },
                                      failure:
            {
                (error) in
                
                
                print("Review Image Error = ",error)
        })
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    
    func splitIntoTwoDigits (input: Int) ->( firstDigit : Int, secondDigit : Int)
    {
        return (input/10,input%10)
    }
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ElapsedTimeViewController") as! ElapsedTimeViewController
//            vc.bookingDetails  = self.bookingDetails
//            self.present(vc, animated: true, completion: nil)
        let alert = UIAlertController(title: "Confirm".localized(), message: "Are you sure you have finished the job?".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            let bookingId = self.bookingDetails["id"]?.stringValue
            
            self.finishJob(bookingId: bookingId)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
//    {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        uploadImage(img: image)
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
//    {
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    
//    func uploadImage(img: UIImage)
//    {
//
//        var headers : HTTPHeaders!
//        if let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
//        {
//            headers = [
//                "Authorization": accesstoken,
//                "Accept": "application/json"
//            ]
//        }
//        else
//        {
//            headers = [
//                "Authorization": "",
//                "Accept": "application/json"
//            ]
//        }
//
//        let url = "\(Constants.baseURL)/imageupload"
//        print("URL:",url)
//        _ = try! URLRequest(url: url, method: .post)
//        //        let img = self.profilePicFld.backgroundImage(for: UIControlState.normal)
//        let imagedata = UIImageJPEGRepresentation(img, 1.0)
//
//
//        SwiftSpinner.show("Uploading".localized())
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            if let data = imagedata{
//                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
//            }
//        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { (result) in
//
//            switch result
//            {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print(response)
//                    let jsonResponse = JSON(response.result.value)
//                    print(jsonResponse)
//                    self.imageString = jsonResponse["image"].stringValue
//                    print(self.imageString)
//
//
//                    self.finishJob()
//
//                    print("Succesfully uploaded")
//                    if let err = response.error
//                    {
//
//                        SwiftSpinner.hide()
//
//                        print(err)
//                        return
//                    }
//                }
//            case .failure(let error):
//
//
//                SwiftSpinner.hide()
//
//                print("Error in upload: \(error.localizedDescription)")
//            }
//        })
//
//    }
    
    
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MiscellaneousViewController") as! MiscellaneousViewController
                vc.bookingDetails  = self.bookingDetails
                vc.addressString = self.addressString
                self.present(vc, animated: true, completion: nil)
                
                
                //self.presentPOP()
        })
        
        
    }
    
    
    func presentPOP()
    {
//        let alertController = UIAlertController(title: "Alert".localized(), message: "Select the option".localized(), preferredStyle: .alert)
//
//        let action1 = UIAlertAction(title: "Take Photo".localized(), style: .default)
//        {
//            (action:UIAlertAction) in
//            print("You've pressed default");
//
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: {
//                action in
//
//                picker.sourceType = .camera
//                picker.allowsEditing = true
//                self.present(picker, animated: true, completion: nil)
//            }))
//            alert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .default, handler: {
//                action in
//                picker.sourceType = .photoLibrary
//                picker.allowsEditing = true
//                self.present(picker, animated: true, completion: nil)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//        }
//
//        let action2 = UIAlertAction(title: "Skip".localized(), style: .cancel) { (action:UIAlertAction) in
//            print("You've pressed cancel");
//
//            self.finishJob()
//        }
//
//
//        alertController.addAction(action1)
//        alertController.addAction(action2)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func userDefaultAlreadyExist(kUsernameKey: String) -> Bool
    {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
    func finishJob(bookingId : String!)
    {
        
        
        if userDefaultAlreadyExist(kUsernameKey: "lastKnownLatitude")
        {
            lat = UserDefaults.standard.object(forKey:"lastKnownLatitude") as! String
            log = UserDefaults.standard.object(forKey:"lastKnownLongitude") as! String
            
            self.getAddressFromLatLon(pdblLatitude: lat, withLongitude: log)
            
        }
        else
        {
        
        
        
        
//
//        let alertController = UIAlertController(title: "Alert".localized(), message: "Select the option".localized(), preferredStyle: .alert)
//
//        let action1 = UIAlertAction(title: "Upload Photo".localized(), style: .default)
//        {
//            (action:UIAlertAction) in
//            print("You've pressed default");
//
//            let picker = UIImagePickerController()
//            picker.delegate = self
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: {
//                action in
//
//                picker.sourceType = .camera
//                picker.allowsEditing = true
//                self.present(picker, animated: true, completion: nil)
//            }))
//            alert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .default, handler: {
//                action in
//                picker.sourceType = .photoLibrary
//                picker.allowsEditing = true
//                self.present(picker, animated: true, completion: nil)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//
//
//        }
//
//        let action2 = UIAlertAction(title: "Skip".localized(), style: .cancel) { (action:UIAlertAction) in
//            print("You've pressed cancel");
//
//            self.finishJob()
//        }
//
//        alertController.addAction(action1)
//        alertController.addAction(action2)
//        self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    
   
    
    
//    func finishJob()
//    {
//
//        var headers : HTTPHeaders!
//        if let accesstoken = UserDefaults.standard.string(forKey: "access_token") as String!
//        {
//            headers = [
//                "Authorization": accesstoken,
//                "Accept": "application/json"
//            ]
//        }
//        else
//        {
//            headers = [
//                "Authorization": "",
//                "Accept": "application/json"
//            ]
//        }
//
//
//        let currentDateTime = Date()
//
//        // initialize the date formatter and set the style
//        let formatter = DateFormatter()
//        formatter.timeStyle = .medium
//        formatter.dateStyle = .none
//
//        formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
//
//
//        let bookingId = self.bookingDetails["id"]?.stringValue
//        var booking = ""
//        if SharedObject().hasData(value: bookingId){
//            booking = bookingId!
//        }
//
//        let params: Parameters = [
//            "id": booking,
//            "end_image":imageString,
//            "end_lat":lat,
//            "end_long":log,
//            "end_address":addressString,
//            "end_time":currentDateTime
//        ]
//
//
//        print("Finish params = ", params)
//
//
//        SwiftSpinner.show("Finishing the Job...".localized())
//        let url = APIList().getUrlString(url: .FINISHJOB)
////        let url = "\(Constants.baseURL)/completedjob"
//        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
//
//            if(response.result.isSuccess)
//            {
//                SwiftSpinner.hide()
//                self.timer.invalidate()
//                if let json = response.result.value {
//                    print("COMPLETE JOB JSON: \(json)") // serialized json response
//                    let jsonResponse = JSON(json)
//
//
//                    if(jsonResponse["error"].stringValue == "true")
//                    {
//                        let errorMessage = jsonResponse["error_message"].stringValue
//                        self.showAlert(title: "Failed".localized(),msg: errorMessage)
//                    }
//                    else{
//                        let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
//                        let vc = stoaryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//                        self.present(vc, animated: true, completion: nil)
//                    }
//                }
//            }
//            else{
//                SwiftSpinner.hide()
//                print(response.error.debugDescription)
//                self.showAlert(title: "Oops".localized(), msg: response.error!.localizedDescription)
//            }
//        }
//    }
    
    
    
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
    @IBAction func cancelAction(_ sender: Any) {
        
        let bookingId = self.bookingDetails["booking_order_id"]!.stringValue
        print("bookingid = \(bookingId)")
        let alert = UIAlertController(title: "Confirm".localized(), message: "Are you sure you want to cancel this booking?".localized(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            print ("YES. CANCEL BOOKING ID :\(bookingId)")
            let bookingId = self.bookingDetails["id"]?.stringValue
            print(bookingId)
            self.cancelBooking(bookingId: bookingId!)
        }))
        
        
        alert.addAction(UIAlertAction(title: "No".localized(), style: UIAlertActionStyle.default, handler: {
            (alert: UIAlertAction!) in
            print ("NO.DONT CANCEL BOOKING ID :\(bookingId)")
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    /*func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
*/
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceStatusTableViewCell", for: indexPath) as! ServiceStatusTableViewCell
        cell.statusIdentifier.text = statusArray[indexPath.row]
        print("times = \(timeStampArray[indexPath.row])")
        cell.statusTime.text = getReadableDate(inputDate: timeStampArray[indexPath.row])
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                      
        }
        if(indexPath.row == 0)
        {
            cell.statusIdentifier.textColor = UIColor.lightGray
            cell.centerCircle.layer.borderWidth = 1
//            cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
//            cell.centerCircle.backgroundColor = UIColor.white
            cell.topLine.isHidden = true
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                cell.centerCircle.layer.borderColor = mycolor.cgColor
                cell.centerCircle.backgroundColor = UIColor.white
                cell.bottomLine.backgroundColor = mycolor
                cell.bottomLine.isHidden = false
            }
            else
            {
                cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
                cell.centerCircle.backgroundColor = UIColor.white
                cell.bottomLine.isHidden = false
            }
//            if UserDefaults.standard.object(forKey: "myColor") != nil
//            {
//                //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
//                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
//                //            var color: UIColor? = nil
//                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
//                cell.bottomLine.backgroundColor = mycolor
//            }
//            else{
//                cell.bottomLine.isHidden = false
//            }
            if(indexPath.row == statusArray.count - 1)
            {
                cell.bottomLine.isHidden = true
                
            }
        }
        else if(indexPath.row == statusArray.count-1)
        {
            cell.statusIdentifier.textColor = UIColor(red:0.20, green:0.21, blue:0.28, alpha:1.0)
            
            cell.centerCircle.layer.borderWidth = 1
//            cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
//            cell.centerCircle.backgroundColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0)
//            cell.topLine.isHidden = false
             cell.bottomLine.isHidden = true
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                cell.topLine.isHidden = false
                cell.topLine.backgroundColor = mycolor
                cell.centerCircle.layer.borderColor = mycolor.cgColor
                cell.centerCircle.backgroundColor = mycolor
            }
            else
            {
                cell.topLine.isHidden = false
                cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
                cell.centerCircle.backgroundColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0)
            }
        }
        else{
            cell.statusIdentifier.textColor = UIColor.lightGray
            cell.centerCircle.layer.borderWidth = 1
//            cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
//            cell.centerCircle.backgroundColor = UIColor.white
            
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                cell.topLine.isHidden = false
                cell.bottomLine.isHidden = false
                cell.topLine.backgroundColor = mycolor
                cell.bottomLine.backgroundColor = mycolor
                cell.centerCircle.layer.borderColor = mycolor.cgColor
                cell.centerCircle.backgroundColor = UIColor.white
            }
            else
            {
                cell.centerCircle.layer.borderColor = UIColor(red:0.42, green:0.50, blue:0.99, alpha:1.0).cgColor
                cell.centerCircle.backgroundColor = UIColor.white
                cell.topLine.isHidden = false
                cell.bottomLine.isHidden = false
            }
            
        }
        return cell
    }
    
    func getReadableDate(inputDate : String) -> String
    {
        print(inputDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+05:30") //Current time zone
        if let date = dateFormatter.date(from: inputDate) //according to date format your date string
        {
            print(date) //Convert String to Date
            
            dateFormatter.dateFormat = "d MMM, yyyy HH:mm a" //Your New Date format as per requirement change it own
            let newDate = dateFormatter.string(from: date) //pass Date here
            
            print(newDate) //New formatted Date string
            return newDate
        }
        else{
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func showDirections(_ sender: Any) {
        let latitude = self.bookingDetails["user_latitude"]!.stringValue
        let longitude = self.bookingDetails["user_longitude"]!.stringValue
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
    
    
    @IBAction func btnMessages(_ sender: Any)
    {
        let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let dvc = stoaryboard.instantiateViewController(withIdentifier: "ChatViewController")as! ChatViewController
        dvc.receiverId = bookingDetails["user_id"]!.stringValue
        dvc.bookingId = bookingDetails["id"]!.stringValue
        dvc.modalTransitionStyle = .crossDissolve
        
        self.present(dvc, animated: true, completion: nil)
        
    }
    
    
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
        
        var booking = ""
        if SharedObject().hasData(value: bookingId){
            booking = bookingId
        }
        let params: Parameters = [
            "id": booking
        ]
        print("parameters",params)
        SwiftSpinner.show("Cancelling your Booking...".localized())
        let url = APIList().getUrlString(url: .CANCEL_BY_PROVIDER)
//        let url = "\(Constants.baseURL)/cancelbyprovider"
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
                        var stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let vc = stoaryboard.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                         self.showAlert(title: "Oops".localized(), msg: "The Booking has been canceled")
                        self.cancledelegate.cancel()
//                        self.view.willRemoveSubview(floaty)
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
    
    @IBAction func bookingDetailsAtn(_ sender: Any)
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "SecondStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BiilingDetailsViewController") as! BiilingDetailsViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.bookingDetails = self.bookingDetails["invoicedetails"]?.arrayValue[0].dictionaryValue
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension Date
{
    func offsetFrom(date: Date) -> (hours: Int, minutes: Int, seconds: Int)
    {
        let hourMinuteSecond: Set<Calendar.Component> = [.hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(hourMinuteSecond, from: date, to: self);
        
        return (difference.hour!,difference.minute!,difference.second!)
    }
}

extension BookingDetailsViewController : FloatyDelegate
{
    // MARK: - Floaty Delegate Methods
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
    }
    
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
    }
    
    func floatyWillClose(_ floaty: Floaty)
    {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close",floaty)
    }
    
}
