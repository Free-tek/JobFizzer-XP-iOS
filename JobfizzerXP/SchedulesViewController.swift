//
//  SchedulesViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 15/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class SchedulesViewController: UIViewController,TimeSelectionDelegate, OfflineViewControllerDelegate {
    
    
    
    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var tueBtn: UIButton!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var thuBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    @IBOutlet weak var satBtn: UIButton!
    @IBOutlet weak var sunBtn: UIButton!
    
    
    var addClicked = "yes"
    
    @IBOutlet weak var btnUpate: UIButton!
    var monday : [JSON] = []
    var tuesday : [JSON] = []
    var wednesday : [JSON] = []
    var thursday : [JSON] = []
    var friday : [JSON] = []
    var saturday : [JSON] = []
    var sunday : [JSON] = []
    var timeSlots : [JSON] = []
    
    @IBOutlet weak var mondayAddButton: UIButton!
    @IBOutlet weak var mondayLbl: UILabel!
    
    @IBOutlet weak var tuesdayAddButton: UIButton!
    @IBOutlet weak var tuesdayLbl: UILabel!
    
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var wednesdayAddButton: UIButton!
    
    @IBOutlet weak var thursdayAddButton: UIButton!
    @IBOutlet weak var thursdayLbl: UILabel!
    
    @IBOutlet weak var fridayAddButton: UIButton!
    @IBOutlet weak var fridayLbl: UILabel!
    
    @IBOutlet weak var saturdayAddButton: UIButton!
    @IBOutlet weak var saturdayLbl: UILabel!
    
    @IBOutlet weak var sundayAddButton: UIButton!
    @IBOutlet weak var sundayLbl: UILabel!
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mondayLbl.font = FontBook.Regular.of(size: 12)
        tuesdayLbl.font = FontBook.Regular.of(size: 12)
        wednesdayLbl.font = FontBook.Regular.of(size: 12)
        thursdayLbl.font = FontBook.Regular.of(size: 12)
        fridayLbl.font = FontBook.Regular.of(size: 12)
        saturdayLbl.font = FontBook.Regular.of(size: 12)
        sundayLbl.font = FontBook.Regular.of(size: 12)
        
        
        monBtn.setTitle("MON".localized(), for: .normal)
        tueBtn.setTitle("TUE".localized(), for: .normal)
        wedBtn.setTitle("WED".localized(), for: .normal)
        thuBtn.setTitle("THU".localized(), for: .normal)
        friBtn.setTitle("FRI".localized(), for: .normal)
        satBtn.setTitle("SAT".localized(), for: .normal)
        sunBtn.setTitle("SUN".localized(), for: .normal)
        
        mondayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        tuesdayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        wednesdayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        thursdayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        fridayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        saturdayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        sundayAddButton.setTitle("ADD TIME".localized(), for: .normal)
        
        monBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        tueBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        wedBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        thuBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        friBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        satBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        sunBtn.titleLabel?.font = FontBook.Regular.of(size: 12)
        
        
        mondayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        tuesdayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        wednesdayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        thursdayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        fridayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        saturdayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        sundayAddButton.titleLabel?.font = FontBook.Medium.of(size: 10)
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            
            mondayAddButton.setTitleColor(mycolor, for: .normal)
            tuesdayAddButton.setTitleColor(mycolor, for: .normal)
            wednesdayAddButton.setTitleColor(mycolor, for: .normal)
            thursdayAddButton.setTitleColor(mycolor, for: .normal)
            fridayAddButton.setTitleColor(mycolor, for: .normal)
            saturdayAddButton.setTitleColor(mycolor, for: .normal)
            sundayAddButton.setTitleColor(mycolor, for: .normal)
            //            mondayAddButton.titleLabel?.textColor = mycolor
            //            tuesdayAddButton.titleLabel?.textColor = mycolor
            //            wednesdayAddButton.titleLabel?.textColor = mycolor
            //            thursdayAddButton.titleLabel?.textColor = mycolor
            //            fridayAddButton.titleLabel?.textColor = mycolor
            //            saturdayAddButton.titleLabel?.textColor = mycolor
            //            sundayAddButton.titleLabel?.textColor = mycolor
            btnUpate.backgroundColor = mycolor
        }
        
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getMySchedules()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            
            mondayAddButton.setTitleColor(mycolor, for: .normal)
            tuesdayAddButton.setTitleColor(mycolor, for: .normal)
            wednesdayAddButton.setTitleColor(mycolor, for: .normal)
            thursdayAddButton.setTitleColor(mycolor, for: .normal)
            fridayAddButton.setTitleColor(mycolor, for: .normal)
            saturdayAddButton.setTitleColor(mycolor, for: .normal)
            sundayAddButton.setTitleColor(mycolor, for: .normal)
            
            mondayLbl.textColor = mycolor
            tuesdayLbl.textColor = mycolor
            wednesdayLbl.textColor = mycolor
            thursdayLbl.textColor = mycolor
            fridayLbl.textColor = mycolor
            saturdayLbl.textColor = mycolor
            sundayLbl.textColor = mycolor
            btnUpate.backgroundColor = mycolor
        }
        
        self.getAppSettings()
        self.getMySchedules()
        
        
    }
    /*  func showAlert(title: String,msg : String)
     {
     let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
     
     // add an action (button)
     alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
     
     // show the alert
     self.present(alert, animated: true, completion: nil)
     }*/
    
    
    func tryAgain() {
        if addClicked == "yes"{
            getMySchedules()
            dismiss(animated: true, completion: nil)
        }
        else if addClicked == "no"{
            getMySchedules()
            dismiss(animated: true, completion: nil)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func getMySchedules(){
        if Reachability.isConnectedToNetwork() {
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
            
            SwiftSpinner.show("Fetching your Schedule...".localized())
            let url = APIList().getUrlString(url: .VIEW_SHECDULES)
            //        let url = "\(Constants.baseURL)/view_schedules"
            Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("BOOKINGS JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        print(jsonResponse)
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
                            self.timeSlots = jsonResponse["schedules"].arrayValue
                            if(self.timeSlots.count == 0)
                            {
                                for i in 0 ... Constants.timeSlots.count-1{
                                    for dayOfTheWeek in 0 ... 6{
                                        var day:JSON = JSON.init()
                                        switch(dayOfTheWeek){
                                        case 0:
                                            day["days"].stringValue = "Mon"
                                            break
                                        case 1:
                                            day["days"].stringValue = "Tue"
                                            break
                                        case 2:
                                            day["days"].stringValue = "Wed"
                                            break
                                        case 3:
                                            day["days"].stringValue = "Thu"
                                            break
                                        case 4:
                                            day["days"].stringValue = "Fri"
                                            break
                                        case 5:
                                            day["days"].stringValue = "Sat"
                                            break
                                        case 6:
                                            day["days"].stringValue = "Sun"
                                            break
                                        default:
                                            day["days"].stringValue = "Sun"
                                        }
                                        
                                        day["status"].stringValue = "0"
                                        day["time_Slots_id"].stringValue = Constants.timeSlots[i]["id"].stringValue
                                        day["id"].stringValue = "1"
                                        day["timing"].stringValue = ""
                                        if(UserDefaults.standard.value(forKey: "provider_id") != nil){
                                            day["provider_id"].stringValue = UserDefaults.standard.value(forKey: "provider_id") as! String
                                        }
                                        
                                        self.timeSlots.append(day)
                                        print(self.timeSlots)
                                    }
                                }
                            }else{
                                for i in 0 ... Constants.timeSlots.count-1{
                                    for dayOfTheWeek in 0 ... 6{
                                        var day:JSON = JSON.init()
                                        switch(dayOfTheWeek){
                                        case 0:
                                            day["days"].stringValue = "Mon"
                                            break
                                        case 1:
                                            day["days"].stringValue = "Tue"
                                            break
                                        case 2:
                                            day["days"].stringValue = "Wed"
                                            break
                                        case 3:
                                            day["days"].stringValue = "Thu"
                                            break
                                        case 4:
                                            day["days"].stringValue = "Fri"
                                            break
                                        case 5:
                                            day["days"].stringValue = "Sat"
                                            break
                                        case 6:
                                            day["days"].stringValue = "Sun"
                                            break
                                        default:
                                            day["days"].stringValue = "Sun"
                                        }
                                        
                                        day["status"].stringValue = "0"
                                        day["time_Slots_id"].stringValue = Constants.timeSlots[i]["id"].stringValue
                                        day["id"].stringValue = "1"
                                        day["timing"].stringValue = ""
                                        if(UserDefaults.standard.value(forKey: "provider_id") != nil){
                                            day["provider_id"].stringValue = UserDefaults.standard.value(forKey: "provider_id") as! String
                                        }
                                        
                                        self.timeSlots.append(day)
                                        print(self.timeSlots)
                                    }
                                }
                            }
                            self.displaySlotsInLabel()
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
        else {
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            addClicked = "no"
            present(Dvc, animated: true, completion: nil)
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
                        
                        //                        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
                        //                        if(isLoggedIn)
                        //                        {
                        //                            //self.updateDeviceToken()
                        //                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        //                            MainViewController.status = statusArray
                        //                            self.present(vc, animated: true, completion: nil)
                        //                        }
                        //                        else{
                        //                            let isLoggedInSkipped = UserDefaults.standard.bool(forKey: "isLoggedInSkipped")
                        //                            if(isLoggedInSkipped)
                        //                            {
                        //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        //                                MainViewController.status = statusArray
                        //                                self.present(vc, animated: true, completion: nil)
                        //                            }
                        //                        }
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
    
    @IBAction func updateSchedule(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
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
            
            let schedule = String(describing: self.timeSlots)
            let params: Parameters = [
                "schedules":schedule
            ]
            SwiftSpinner.show("Updating Schedules...".localized())
            let url = APIList().getUrlString(url: .UPDATE_SHEDULES)
            //        let url = "\(Constants.baseURL)/updateschedules"
            Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("UPDATE SCHEDULE JSON: \(json)") // serialized json response
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
                            
                            self.dismiss(animated: true, completion: nil);
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
        else {
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            addClicked = "yes"
            present(Dvc, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTime(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTimeSlotViewController") as! SelectTimeSlotViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.forDay = sender.tag
            print("monday= \(monday.count)")
            print(tuesday.count)
            print(wednesday.count)
            print(thursday.count)
            print(friday.count)
            print(saturday.count)
            print(sunday.count)
            switch sender.tag{
            case 0:
                vc.daysData = monday
                break;
            case 1:
                vc.daysData = tuesday
                break;
            case 2:
                vc.daysData = wednesday
                break;
            case 3:
                vc.daysData = thursday
                break;
            case 4:
                vc.daysData = friday
                break;
            case 5:
                vc.daysData = saturday
                break;
            case 6:
                vc.daysData = sunday
                break;
            default:
                vc.daysData = monday
                break;
            }
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        else {
            addClicked = "yes"
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            present(Dvc, animated: true, completion: nil)
            //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
        }
    }
    
    func displaySlotsInLabel(){
        
        monday.removeAll()
        tuesday.removeAll()
        wednesday.removeAll()
        thursday.removeAll()
        friday.removeAll()
        saturday.removeAll()
        
        for i in 0 ... self.timeSlots.count - 1
        {
            let slot = self.timeSlots[i]
            let slotsData = self.timeSlots[i].dictionaryValue
            print(slotsData)
            let dayOfTheWeek = slotsData["days"]!.stringValue
            print(dayOfTheWeek)
            print(i)
            switch dayOfTheWeek {
            case "Mon":
                monday.append(slot)
                print("monday",monday)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: mondayLbl.text!)
                    if(mondayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    mondayLbl.text = timingString
                    if(mondayLbl.text!.count > 0)
                    {
                        self.mondayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Tue":
                tuesday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: tuesdayLbl.text!)
                    if(tuesdayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    tuesdayLbl.text = timingString
                    if(tuesdayLbl.text!.count > 0)
                    {
                        self.tuesdayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Wed":
                wednesday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: wednesdayLbl.text!)
                    
                    if(wednesdayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    wednesdayLbl.text = timingString
                    if(wednesdayLbl.text!.count > 0)
                    {
                        self.wednesdayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Thu":
                thursday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: thursdayLbl.text!)
                    
                    if(thursdayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    thursdayLbl.text = timingString
                    if(thursdayLbl.text!.count > 0)
                    {
                        self.thursdayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Fri":
                friday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: fridayLbl.text!)
                    if(fridayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    fridayLbl.text = timingString
                    if(fridayLbl.text!.count > 0)
                    {
                        self.fridayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Sat":
                saturday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: saturdayLbl.text!)
                    if(saturdayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    saturdayLbl.text = timingString
                    if(saturdayLbl.text!.count > 0)
                    {
                        self.saturdayAddButton.titleLabel?.text = ""
                    }
                }
                break
            case "Sun":
                sunday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: sundayLbl.text!)
                    if(sundayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    sundayLbl.text = timingString
                    if(sundayLbl.text!.count > 0)
                    {
                        self.sundayAddButton.titleLabel?.text = ""
                    }
                }
                break
            default:
                monday.append(slot)
                if(slotsData["status"]!.intValue == 1){
                    var timingString = String(describing: mondayLbl.text!)
                    
                    if(mondayLbl.text == "")
                    {
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    else{
                        timingString.append(", ")
                        let currentTimeSlot = slotsData["timing"]!.stringValue
                        timingString.append(currentTimeSlot)
                    }
                    
                    mondayLbl.text = timingString
                    if(mondayLbl.text!.count > 0)
                    {
                        self.mondayAddButton.titleLabel?.text = ""
                    }
                }
            }
        }
    }
    
    func changeStatus(timeSlotId: String, dayOfTheWeek: Int, status: String){
        var count = 0;
        print("tms",self.timeSlots,timeSlotId,dayOfTheWeek,status)
        for i in 0 ... Constants.timeSlots.count-1{
            
            //print("count",count)
            //print(Constants.timeSlots.count-1)
            for dotw in 0 ... 6{
                if(Constants.timeSlots[i]["id"].stringValue == timeSlotId && dotw == dayOfTheWeek){
                    //print("status *****",self.timeSlots[count]["status"].stringValue)
                    //print("status *2",status)
                    self.timeSlots[count]["status"].stringValue = status
                    print("tms count",self.timeSlots.count)
                }
                count = count + 1
            }
            
        }
        print("tms",self.timeSlots)
    }
    
    func didFinishSelectingTime(slotsData: [JSON], dayOfTheWeek : Int) {
        switch dayOfTheWeek {
        case 0:
            monday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(monday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(monday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            mondayLbl.text = displayString
            if(mondayLbl.text!.count > 0)
            {
                self.mondayAddButton.titleLabel?.text = ""
            }
            
        case 1:
            tuesday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(tuesday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(tuesday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            tuesdayLbl.text = displayString
            if(tuesdayLbl.text!.count > 0)
            {
                self.tuesdayAddButton.titleLabel?.text = ""
            }
        case 2:
            wednesday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(wednesday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(wednesday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            wednesdayLbl.text = displayString
            if(wednesdayLbl.text!.count > 0)
            {
                self.wednesdayAddButton.titleLabel?.text = ""
            }
            
        case 3:
            thursday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(thursday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(thursday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            thursdayLbl.text = displayString
            if(thursdayLbl.text!.count > 0)
            {
                self.thursdayAddButton.titleLabel?.text = ""
            }
        case 4:
            friday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(friday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(friday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            fridayLbl.text = displayString
            if(fridayLbl.text!.count > 0)
            {
                self.fridayAddButton.titleLabel?.text = ""
            }
        case 5:
            saturday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(saturday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(saturday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            saturdayLbl.text = displayString
            if(saturdayLbl.text!.count > 0)
            {
                self.saturdayAddButton.titleLabel?.text = ""
            }
            
        case 6:
            sunday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(sunday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(sunday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            sundayLbl.text = displayString
            if(sundayLbl.text!.count > 0)
            {
                self.sundayAddButton.titleLabel?.text = ""
            }
            
        default:
            monday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(monday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(monday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            mondayLbl.text = displayString
            if(mondayLbl.text!.count > 0)
            {
                self.mondayAddButton.titleLabel?.text = ""
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
