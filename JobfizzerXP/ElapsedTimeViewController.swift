//
//  ElapsedTimeViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 02/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON

class ElapsedTimeViewController: UIViewController {
    var bookingDetails : [String:JSON]!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(bookingDetails)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    @IBAction func finishJob(_ sender: Any) {
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
        
        let bookingId = self.bookingDetails["id"]?.stringValue
        var booking = ""
        if SharedObject().hasData(value: bookingId){
            booking = bookingId!
        }
        let params: Parameters = [
            "id": booking
        ]
        
        
        SwiftSpinner.show("Finishing the Job...")
//        let url = "\(Constants.baseURL)/completedjob"
        let url = APIList().getUrlString(url: .FINISHJOB)
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("COMPLETE JOB JSON: \(json)") // serialized json response
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
                self.showAlert(title: "Oops", msg: response.error!.localizedDescription)
            }
        }
    }
    

}
