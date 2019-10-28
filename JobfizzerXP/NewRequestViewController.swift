//
//  NewRequestViewController.swift
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

class NewRequestViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var acceptLbl: UILabel!
    @IBOutlet weak var rejectLbl: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bookingDescription: UILabel!
    var mycolor = UIColor()
    var bookingRequestType : String = ""
    var bookingDetail : [String:JSON]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLbl.text = "NEW REQUEST!!".localized()
        acceptLbl.text = "ACCEPT".localized()
        rejectLbl.text = "REJECT".localized()
        
        titleLbl.font = FontBook.Medium.of(size: 18)
        userName.font = FontBook.Medium.of(size: 17)
        bookingDescription.font = FontBook.Regular.of(size: 14)
        acceptLbl.font = FontBook.Regular.of(size: 12)
        rejectLbl.font = FontBook.Regular.of(size: 12)
        
        
        
        print(bookingDetail)
        
        let name = bookingDetail["Name"]!.stringValue
        self.userName.text = name
        
        if let image = bookingDetail["userimage"]?.stringValue{
            if let imageURL = URL.init(string: image){
                
                Nuke.loadImage(with: imageURL, into: self.userImage)
            }
        }
        
        if let servicename = bookingDetail["sub_category_name"]?.stringValue
        {
            
            if let dateSlot = bookingDetail["booking_date"]?.stringValue{
                
                if let timeSlot = bookingDetail["timing"]?.stringValue{
                    
                    let formattedString = NSMutableAttributedString()
                    formattedString
                        .bold(name)
                        .normal(" has sent you a request for ".localized())
                        .bold(servicename)
                        .normal(" at ".localized())
                        .bold(dateSlot)
                        .normal(" for the slot ".localized())
                        .bold(timeSlot)
                    
                    self.bookingDescription.attributedText = formattedString
                }
                else{
                    
                    let formattedString = NSMutableAttributedString()
                    formattedString
                        .bold(name)
                        .normal(" has sent you a request for ".localized())
                        .bold(servicename)
                        .normal(" at ".localized())
                        .bold(dateSlot)
                    self.bookingDescription.attributedText = formattedString
                }
            }
            else{
                let formattedString = NSMutableAttributedString()
                formattedString
                    .bold(name)
                    .normal(" has sent you a request for ".localized())
                    .bold(servicename)
                self.bookingDescription.attributedText = formattedString
            }
        }
        else{
            let formattedString = NSMutableAttributedString()
            formattedString
                .bold(name)
                .normal(" has sent you a request. ".localized())
            self.bookingDescription.attributedText = formattedString
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            if let image = bookingDetail["userimage"]?.stringValue
            {
                if let imageURL = URL.init(string: image)
                {
                    
                    Nuke.loadImage(with: imageURL, into: self.userImage)
                }
            }
            else
            {
                changeTintColor(userImage, arg: mycolor)
            }
        }
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
    
    /*func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    @IBAction func reject(_ sender: Any) {
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
        
        let bookingId = self.bookingDetail["id"]?.stringValue
        var booking = ""
        if SharedObject().hasData(value: bookingId)
        {
            booking = bookingId!
        }
        let params: Parameters = [
            "id": booking
        ]
        var url = ""
        if(bookingRequestType != "random")
        {
             url = APIList().getUrlString(url: .REJECT_BOOKING)
//            url = "\(Constants.baseURL)/rejectbooking"
        }
        else{
             url = APIList().getUrlString(url: .REJECT_RANDOM_REQUEST)
//            url = "\(Constants.baseURL)/reject_random_request"
        }
        
        SwiftSpinner.show("Rejecting your booking...".localized())
        //        let url = "\(Constants.baseURL)/rejectbooking"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("ACCEPT BOOKING JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    
                    
                    if(jsonResponse["error"].stringValue == "true")
                    {
                        let errorMessage = jsonResponse["error_message"].stringValue
                        self.showAlert(title: "Failed",msg: errorMessage)
                    }
                    else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                        
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
    @IBAction func accept(_ sender: Any) {
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
        
        let bookingId = self.bookingDetail["id"]?.stringValue
        var booking = ""
        if SharedObject().hasData(value: bookingId)
        {
            booking = bookingId!
        }
        let params: Parameters = [
            "id": booking
        ]
        var url = ""
        
        SwiftSpinner.show("Accepting your booking...".localized())
        if(bookingRequestType != "random")
        {
             url = APIList().getUrlString(url: .ACCEPT_BOOKING)
//            url = "\(Constants.baseURL)/acceptbooking"
        }
        else{
             url = APIList().getUrlString(url: .ACCEPT_RANDOM_BOOKING)
//            url = "\(Constants.baseURL)/accept_random_request"
        }
        //        let url = "\(Constants.baseURL)/acceptbooking"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("ACCEPT BOOKING JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    
                    
                    if(jsonResponse["error"].stringValue == "true")
                    {
                        let errorMessage = jsonResponse["error_message"].stringValue
                        self.showAlert(title: "Failed".localized(),msg: errorMessage)
                    }
                    else
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Ubuntu-Bold", size: 14)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Ubuntu-Regular", size: 14)!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        
        return self
    }
}

