//
//  CalendarViewController.swift
//  Wedoinstall pro
//
//  Created by admin on 9/10/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Nuke

class CalendarViewController: UIViewController,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance, BookDelegate
{
    @IBOutlet weak var titleLbl: UILabel!
    var color1: UIColor = UIColor.init(red: 107 / 255, green: 127 / 255, blue: 252 / 255, alpha: 1.0)
    
    func getBackMethod()
    {
     
        calender.delegate = self
        calender.dataSource = self
        calender.reloadData()
    }
    

    @IBOutlet weak var calender: FSCalendar!
    
    var dates :[JSON] = []
    var mycolor = UIColor()
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
   
    
   
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        mycolor = UIColor.clear
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        print("result =",result)
        calendershedule(date: result)
        
        
        titleLbl.text = "Appointments".localized()
        titleLbl.font = FontBook.Regular.of(size: 17)
        
        
        calender.allowsMultipleSelection = false
        calender.allowsSelection = true
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
//    override func viewDidAppear(_ animated: Bool)
//    {
//        calender.delegate = self
//        calender.dataSource = self
//        calender.reloadData()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        print("calendar did select date \(self.dateFormatter1.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    
        
        let key = self.dateFormatter1.string(from: date)
        
        for index in 0..<self.dates.count
        {
            if key == self.dates[index]["booking_date"].stringValue
            {
                
//                calendar.dataSource = nil
//                calendar.delegate = nil
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "BookHomeViewController") as! BookHomeViewController
                vc.date = key
//                vc.delegate = self
                self.present(vc, animated: true, completion: nil)                                
                break;
            }
            
        }
        
        
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            return mycolor
            
        }else{
            //let colordata = NSKeyedArchiver.archivedData(withRootObject: color1)
            return color1
        }
        //return UIColor.cyan
    }



    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return UIColor.black
    }
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return dates.count
    }
    
    
    @IBAction func btnback(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?
    {
    
        
        let key = self.dateFormatter1.string(from: date)
        
        for index in 0..<self.dates.count
        {
            if key == self.dates[index]["booking_date"].stringValue
            {
//                    return UIColor.cyan
                if UserDefaults.standard.object(forKey: "myColor") != nil
                {
                    return mycolor
                    
                }else {
//                    return UIColor.blue
                    //let colordata = NSKeyedArchiver.archivedData(withRootObject: color1)
                    return color1
                }
            }
            
        }
        return nil
    }
  
    func calendarCurrentPageDidChange(_ calendar: FSCalendar)
    {
        print("calendarCurrentPageDidChange = ",calender.currentPage)
        
        
        let date = calender.currentPage
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        calendershedule(date: result)

    }
    
    
    
    func calendershedule(date : String)
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
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        
        formatter.string(from: currentDateTime)
        
        let params: Parameters = [
            "date": date,
        ]
        
        
        print("Finish params = ", params)
        
        
        SwiftSpinner.show("Fetching Details...".localized())
        let url = APIList().getUrlString(url: .PROVIDER_CALENDER)
        print(url)
//        let url = "\(Constants.baseURL)/providercalender"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()

                if let json = response.result.value {
                    print("Fetching Calender Booking JSON: \(json)")
                    let jsonResponse = JSON(json)
                    
                    
                    if(jsonResponse["error"].stringValue == "true")
                    {
                        let errorMessage = jsonResponse["error_message"].stringValue
                        self.showAlert(title: "Failed".localized(),msg: errorMessage)
                    }
                    else if jsonResponse["error"].stringValue == ""{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else
                    {
                        self.dates = jsonResponse["providerworkingdetails"].arrayValue
                        let date = self.dates
                        self.calender.reloadData()
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
    
  /*  func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }*/
    
   

}
