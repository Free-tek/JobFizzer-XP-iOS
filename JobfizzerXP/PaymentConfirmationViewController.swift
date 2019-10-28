//
//  PaymentConfirmationViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 02/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SwiftyJSON


class PaymentConfirmationViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var confirmLbl: UILabel!
    @IBOutlet weak var vwtop: UIView!
    @IBOutlet weak var imgPaymentWaiting: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    var bookingId : String!
    var mycolor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = "PAYMENT CONFIRMATION".localized()
        confirmLbl.text = "Confirm that if you've received payment from the client.".localized()
        btnConfirm.setTitle("PAYMENT RECEIVED".localized(), for: .normal)
        imgPaymentWaiting.tintColor = UIColor.white
        titleLbl.font = FontBook.Medium.of(size: 20)
        confirmLbl.font = FontBook.Medium.of(size: 20)
        btnConfirm.titleLabel!.font = FontBook.Regular.of(size: 16)
        vwtop.layer.cornerRadius = vwtop.frame.size.width / 2
        vwtop.layer.masksToBounds = true
        print(bookingId)
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
            imgPaymentWaiting.tintColor = UIColor.white
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnConfirm.backgroundColor = mycolor
            titleLbl.textColor = mycolor
            vwtop.backgroundColor = mycolor
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
//            imgPaymentWaiting.tintColor = UIColor.white
            
            let templateImage = self.imgPaymentWaiting.image?.withRenderingMode(.alwaysTemplate)
            self.imgPaymentWaiting.image = templateImage
            self.imgPaymentWaiting.tintColor = UIColor.white
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnConfirm.backgroundColor = mycolor
            titleLbl.textColor = mycolor
            vwtop.backgroundColor = mycolor
        }
    }
    
  /*  func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func paymentReceived(_ sender: Any) {
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
        if SharedObject().hasData(value: bookingId)
        {
            booking = bookingId!
        }
        let params: Parameters = [
            "id": booking
        ]
        
        
        SwiftSpinner.show("Confirming Payment...".localized())
//        let url = "\(Constants.baseURL)/paymentaccept"
        let url = APIList().getUrlString(url: .PAYMENT_ACCEPT)
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
    


}
