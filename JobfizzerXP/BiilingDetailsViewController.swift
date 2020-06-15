//
//  InvoiceViewController.swift
//  SwyftX
//
//  Created by Karthik Sakthivel on 29/10/17.
//  Copyright © 2017 Swyft. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import UserNotifications

class BiilingDetailsViewController: UIViewController,UNUserNotificationCenterDelegate,UITableViewDelegate,UITableViewDataSource
{
    

    @IBOutlet weak var invoiceLbl: UILabel!
    @IBOutlet weak var pnameLbl: UILabel!
    @IBOutlet weak var billNameLbl: UILabel!
    @IBOutlet weak var bidLbl: UILabel!
    @IBOutlet weak var datLbl: UILabel!
    @IBOutlet weak var timLbl: UILabel!
    @IBOutlet weak var whoursLbl: UILabel!
    @IBOutlet weak var prLbl: UILabel!
    @IBOutlet weak var totLbl: UILabel!
    
    @IBOutlet weak var miscellaneousHeadingLbl: UILabel!
    @IBOutlet weak var miscellaneousTableView: UITableView!
    @IBOutlet weak var miscellaneousTableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var taxHeadingLbl: UILabel!
    @IBOutlet weak var taxTableView: UITableView!
    @IBOutlet weak var taxTableHeight: NSLayoutConstraint!
  
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
     var isCoupon_Applied = ""
    
    @IBOutlet weak var couponNameLbl: UILabel!
    @IBOutlet weak var offerLbl: UILabel!
    @IBOutlet weak var discountHeight: NSLayoutConstraint!
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var taxNameLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
   
    @IBOutlet weak var workingHoursLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bookingIdLbl: UILabel!
    @IBOutlet weak var billingNameLbl: UILabel!
    @IBOutlet weak var providerNameLbl: UILabel!

    var bookingDetails : [String:JSON]!

    
    private var price = "0"
    
    @IBOutlet weak var confirmButton: UIButton!
    var mycolor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        invoiceLbl.text = "INVOICE".localized()
        pnameLbl.text = "Provider Name".localized()
        billNameLbl.text = "Billing Name".localized()
        bidLbl.text = "Booking ID".localized()
        datLbl.text = "Date".localized()
        timLbl.text = "Time".localized()
        whoursLbl.text = "Working Hours".localized()
        prLbl.text = "Price".localized()
        taxNameLbl.text = "Tax".localized()
        totLbl.text = "TOTAL".localized()

        couponNameLbl.text = "Discount".localized()

        invoiceLbl.font = FontBook.Medium.of(size: 20)
        pnameLbl.font = FontBook.Regular.of(size: 16)
        billNameLbl.font = FontBook.Regular.of(size: 16)
        bidLbl.font = FontBook.Regular.of(size: 16)
        datLbl.font = FontBook.Regular.of(size: 16)
        timLbl.font = FontBook.Regular.of(size: 16)
        whoursLbl.font = FontBook.Regular.of(size: 16)
        prLbl.font = FontBook.Regular.of(size: 16)
        taxNameLbl.font = FontBook.Regular.of(size: 16)
        totLbl.font = FontBook.Regular.of(size: 16)

        
        
        offerLbl.font = FontBook.Regular.of(size: 16)
        providerNameLbl.font = FontBook.Regular.of(size: 16)
        billingNameLbl.font = FontBook.Regular.of(size: 16)
        bookingIdLbl.font = FontBook.Regular.of(size: 16)
        dateLbl.font = FontBook.Regular.of(size: 16)
        timeLbl.font = FontBook.Regular.of(size: 16)
        workingHoursLbl.font = FontBook.Regular.of(size: 16)
        priceLbl.font = FontBook.Regular.of(size: 16)
        taxLbl.font = FontBook.Regular.of(size: 16)
        totalLbl.font = FontBook.Regular.of(size: 16)

        
        
        
        print("Billing Details = ",bookingDetails)
        
        miscellaneousTableView.dataSource = self
        miscellaneousTableView.delegate = self
        miscellaneousTableHeight.constant = 0
        miscellaneousTableView.separatorStyle = .none
        
        miscellaneousHeadingLbl.text = "Miscellaneous Details".localized()
        taxHeadingLbl.text = "Tax Details".localized()
        
        
        taxTableView.delegate = self
        taxTableView.dataSource = self
        taxTableHeight.constant = 0
        taxTableView.separatorStyle = .none

        
        isCoupon_Applied = self.bookingDetails["coupon_applied"]!.stringValue
        
        print("isCoupon_Applied = ",isCoupon_Applied)
        
        self.offerLbl.textColor = UIColor.red

        
        if isCoupon_Applied == ""
        {
            self.offerLbl.text = "-0"
            couponNameLbl.text = "-Nil-".localized()
            discountHeight.constant = 0

            
        }
        else
        {
            self.offerLbl.text = "-" + self.bookingDetails["off"]!.stringValue
            let str1 = "Discount"
            var str2 = isCoupon_Applied.uppercased()
            couponNameLbl.text = "\(str1) (\(str2))"
            discountHeight.constant = 18

        }
       
        self.totalLbl.text = "₦ \(String(describing: self.bookingDetails["total_cost"]!.stringValue))"
        
        self.price = self.bookingDetails["total_cost"]!.stringValue
        self.taxNameLbl.text = "\(String(describing: self.bookingDetails["tax_name"]!.stringValue)) (\(self.bookingDetails["gst_percent"]!.stringValue)%)"
        self.taxLbl.text = "₦ \(String(describing: self.bookingDetails["gst_cost"]!.stringValue))"
        self.priceLbl.text = "₦ \(String(describing: self.bookingDetails["cost"]!.stringValue))"
        let workhrs = minutesToHoursMinutes(minutes: self.bookingDetails["worked_mins"]!.intValue)
        
        if(workhrs.hours > 0)
        {
            let hr = "Hr".localized()
            let mins = "mins".localized()
            self.workingHoursLbl.text = "\(workhrs.hours) \(hr) & \(workhrs.leftMinutes) \(mins)"
            let arr = self.bookingDetails["alltax"]!.arrayValue
            if(arr.count == 0){
                taxTableHeight.constant = 0
            }else{
                taxTableHeight.constant = CGFloat(arr.count * 33)+33
            }
            
            let miscArr = self.bookingDetails["material_details"]!.arrayValue
            if(miscArr.count == 0){
                miscellaneousTableHeight.constant = 0
            }else{
                miscellaneousTableHeight.constant = CGFloat(miscArr.count * 33)+33
            }
        }
        else{
            let mins = "mins".localized()
            self.workingHoursLbl.text = "\(workhrs.leftMinutes) \(mins)"
            if workhrs.leftMinutes <= 1
            {
                let arr = self.bookingDetails["alltax"]!.arrayValue
                if(arr.count == 0){
                    taxTableHeight.constant = 0
                }else{
                    taxTableHeight.constant = CGFloat(arr.count * 33)+33
                }
                
                let miscArr = self.bookingDetails["material_details"]!.arrayValue
                if(miscArr.count == 0)
                {
                    miscellaneousTableHeight.constant = 0
                }
                else
                {
                    miscellaneousTableHeight.constant = CGFloat(miscArr.count * 33)+33
                }
                //                 taxTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            }
            else {
                let arr = self.bookingDetails["alltax"]!.arrayValue
                if(arr.count == 0){
                    taxTableHeight.constant = 0
                }else{
                    taxTableHeight.constant = CGFloat(arr.count * 33)+33
                }
                
                let miscArr = self.bookingDetails["material_details"]!.arrayValue
                if(miscArr.count == 0){
                    miscellaneousTableHeight.constant = 0
                }else{
                    miscellaneousTableHeight.constant = CGFloat(miscArr.count * 33)+33
                }
                //                taxTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            }
        }
        
        self.timeLbl.text = self.bookingDetails["timing"]?.stringValue
        self.dateLbl.text = self.bookingDetails["booking_date"]?.stringValue
        self.bookingIdLbl.text = self.bookingDetails["booking_order_id"]?.stringValue
        self.billingNameLbl.text = self.bookingDetails["username"]?.stringValue
        
//        if let first_name = UserDefaults.standard.string(forKey: "first_name") as String!
//        {
//            if let  last_name = UserDefaults.standard.string(forKey: "last_name") as String!{
//                providerNameLbl.text = "\(String(describing: first_name)) \(String(describing: last_name))"
//            }
//            else{
//                providerNameLbl.text = "\(String(describing: first_name))"
//            }
//        }
         self.providerNameLbl.text = self.bookingDetails["providername"]?.stringValue
        
        
//        self.totalLbl.text = "100"
//
//        self.price = "100"
        self.taxNameLbl.text = "VAT"
//        self.taxLbl.text = "YES"
//        self.priceLbl.text = "100"
       
        
//        if(workhrs.hours > 0){
//            self.workingHoursLbl.text = "\(workhrs.hours) Hr & \(workhrs.leftMinutes) mins"
//        }
//        else{
//            self.workingHoursLbl.text = "\(workhrs.leftMinutes) mins"
//        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            confirmButton.backgroundColor = mycolor
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
//        self.taxTableHeight.constant = self.taxTableView.contentSize.height
//        self.miscellaneousTableHeight.constant = self.miscellaneousTableView.contentSize.height
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func initiatePayment(_ sender: Any)
    {
//        presentingViewController?.dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    
}

extension BiilingDetailsViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //        print("Count = ",self.bookingDetails["status"]!["alltax"].arrayValue.count)
        if(tableView == taxTableView){
            return self.bookingDetails["alltax"]!.arrayValue.count
        }else{
            return self.bookingDetails["material_details"]!.arrayValue.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == taxTableView)
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaxTableViewCell", for: indexPath) as! TaxTableViewCell
        
        cell.taxNameLbl.text = "\(self.bookingDetails["alltax"]!.arrayValue[indexPath.row]["taxname"].stringValue) \(self.bookingDetails["alltax"]!.arrayValue[indexPath.row]["tax_amount"].stringValue)% "
        
        cell.taxValueLbl.text = " ₦ \(self.bookingDetails["alltax"]!.arrayValue[indexPath.row]["tax_totalamount"].stringValue)"
        
        cell.selectionStyle = .none
        return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "billingMiscellaneousTableViewCell", for: indexPath) as! billingMiscellaneousTableViewCell
            
            cell.miscellaneousName.text = "\(self.bookingDetails["material_details"]!.arrayValue[indexPath.row]["material_name"].stringValue)"
            
            cell.miscellaneousValue.text = " ₦ \(self.bookingDetails["material_details"]!.arrayValue[indexPath.row]["material_cost"].stringValue)"
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 33
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
/*        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! TaxTableViewCell*/
        
    }
    
}


