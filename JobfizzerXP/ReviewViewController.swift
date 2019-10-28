//
//  ReviewViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 02/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import Alamofire
import SwiftSpinner
import SimpleImageViewer
import SDWebImage


class ReviewViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var helpLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    
    @IBOutlet weak var thanksCardView: CardView!
    @IBOutlet weak var thanksImg: UIImageView!
    @IBOutlet weak var thanksLbl: UILabel!
    @IBOutlet weak var thanksBtn: UIButton!
    
    @IBOutlet weak var beforeImg: UIImageView!
    @IBOutlet weak var afterImg: UIImageView!

    let sharedInstance = Connection()

    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var reviewFld: UITextField!
//    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
//    @IBOutlet weak var topView: UIView!
    var hasAlreadyMoved = false
    var bookingId : String!
    var userId : String!
    var mycolor = UIColor()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        thanksCardView.isHidden = true
        thanksLbl.text = "Thanks for using Jobfizzer XP service".localized()
        
        titleLbl.text = "Give us your rating".localized()
        helpLbl.text = "Help your provider improve their service by rating them".localized()
        aboutLbl.text = "Tell us about our service".localized()
        reviewFld.placeholder = "Type your comments".localized()
        btnConfirm.setTitle("CONFIRM".localized(), for: .normal);
        
        titleLbl.font = FontBook.Medium.of(size: 20)
        helpLbl.font = FontBook.Regular.of(size: 16)
        aboutLbl.font = FontBook.Regular.of(size: 16)
        reviewFld.font = FontBook.Regular.of(size: 15)
        btnConfirm.titleLabel!.font = FontBook.Medium.of(size: 16)
        
        sharedInstance.bookingID = bookingId
        
        self.getImageData()
        
        /*
        
        self.topView.frame.origin.y = self.topView.frame.origin.y + 130
        self.bottomView.frame.origin.y = self.bottomView.frame.origin.y + 270
        ratingView.didFinishTouchingCosmos =
         {
            rating in
            
            if(!self.hasAlreadyMoved)
            {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                    
                    self.hasAlreadyMoved = true
                    self.topView.frame.origin.y = self.topView.frame.origin.y - 130
                    self.bottomView.frame.origin.y = self.bottomView.frame.origin.y - 270
                    
                }) { (Void) in
                    
                }
            }
            print(rating)
        }*/
        
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
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            btnConfirm.backgroundColor = mycolor
            thanksBtn.backgroundColor = mycolor
            thanksImg.tintColor = mycolor
           
        }
    }
    func getImageData()
    {
        SwiftSpinner.show("Loading...".localized())
        
        sharedInstance.postConnection("startjobendjobdetails", success:
        {
                (json) in
                
                SwiftSpinner.hide()
                print("Review Image Json = ",json)
                let jsonResponse = JSON(json)
                
                if(jsonResponse["error"].stringValue == "false")
                {
                    self.beforeImg.sd_setImage(with: URL(string: jsonResponse["data"]["start_image"].stringValue), placeholderImage: UIImage(named: "iconforPlaceholder"))
                    
                    self.afterImg.sd_setImage(with: URL(string: jsonResponse["data"]["end_image"].stringValue), placeholderImage: UIImage(named: "iconforPlaceholder"))
                }
            
        },
        failure:
        {
                (error) in
                
                SwiftSpinner.hide()
            
                print("Review Image Error = ",error)
        })
    }
    
    
    @IBAction func sendReview(_ sender: Any)
    {
        
        if ratingView.rating == 0.0
        {
            self.showAlert(title: "Oops".localized(), msg: "Please provide a rating".localized())
        }
        else
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
            
            let rating = String(ratingView.rating)
            let feedback = reviewFld.text
            print(userId)
            print(bookingId)
            print(rating)
            print(feedback!)
            var booking = ""
            var user = ""
            var rate = ""
            if SharedObject().hasData(value: userId){
                user = userId!
            }
            if SharedObject().hasData(value: bookingId){
                booking = bookingId!
            }
            if SharedObject().hasData(value: rating){
                rate = rating
            }
            let params: Parameters = [
                "id": user,
                "rating": rate ,
                "booking_id":booking,
                "feedback":feedback!
            ]
            print(params)
            
            
            SwiftSpinner.show("Thanks for your review.".localized())
            let url = APIList().getUrlString(url: .USERREVIEWS)
//            let url = "\(Constants.baseURL)/userreviews"
            Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
                
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("REVIEW JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        
                        
                        if(jsonResponse["error"].stringValue == "true")
                        {
                            let errorMessage = jsonResponse["error_message"].stringValue
                            self.showAlert(title: "Failed".localized(),msg: errorMessage)
                        }
                        else{
                            self.thanksCardView.isHidden = false
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
    
    
 /*   func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }*/
    
    @IBAction func okayBtnPressed(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func getReceiptBtn(_ sender: Any)
    {
        
    }
    
    @IBAction func beforeImgBtn(_ sender: Any)
    {
        viewImage(imgView: self.beforeImg)
    }
    
    @IBAction func afterImageBtn(_ sender: Any)
    {
        viewImage(imgView: self.afterImg)
    }
    
    func viewImage(imgView :UIImageView)
    {
        let configuration = ImageViewerConfiguration
        {
            config in
            config.imageView = imgView
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
        
    }

}

