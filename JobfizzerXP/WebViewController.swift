//
//  WebViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 07/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class WebViewController: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: UIWebView!
    var titleString: String = ""
    
    @IBOutlet weak var lblPrivacy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = titleString
        
        //        webView.delegate = self
        
        //        if(titleString == "About Us")
        //        {
        //            getWebContent(key: "aboutus")
        //        }
        //        else if(titleString == "Help and FAQ")
        //        {
        //            getWebContent(key: "faq")
        //        }
        //        else if(titleString == "Terms & Conditions")
        //        {
        //            getWebContent(key: "terms")
        //        }
        getWebContent()
        // Do any additional setup after loading the view.
    }
    
    func getWebContent(){
        
        SwiftSpinner.show("Chargement...".localized())
        let url = "\(Constants.adminBaseURL)/showPag"
        Alamofire.request(url,method: .post).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("WEB JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "Unauthenticated" || jsonResponse["error"].stringValue == "true")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else
                    {
                        let image = jsonResponse["page"][0]["privacyPolicy"].stringValue
                        self.lblPrivacy.text! = image
                        
                    }
                }
            }
            else{
                SwiftSpinner.hide()
                print(response.error.debugDescription)
            }
        }
    }
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    } */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SwiftSpinner.show("Loading")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SwiftSpinner.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SwiftSpinner.hide()
        self.showAlert(title: "Oops".localized(), msg: error.localizedDescription)
    }
    override func viewDidDisappear(_ animated: Bool) {
        SwiftSpinner.hide()
    }
}
