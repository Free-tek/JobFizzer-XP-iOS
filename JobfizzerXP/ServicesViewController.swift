//
//  ServicesViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 14/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class ServicesViewController: UIViewController,AddressSelectionDelegate,UICollectionViewDelegate,UICollectionViewDataSource,EditCategoryDelegate,OfflineViewControllerDelegate {
    func tryAgain() {
        dismiss(animated: true, completion: nil)
    }
    
    func didFinishEditingCategories(selectionDone: Bool) {
        self.getMyServices()
    }
    
    
    @IBOutlet weak var serviceLbl: UILabel!
    @IBOutlet weak var addCatLbl: UILabel!
    
    
    
    
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var bottomAddView: UIView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    
    
    var mycolor = UIColor()
    var categories : [JSON] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceLbl.text = "Services".localized()
        addCatLbl.text = "ADD CATEGORY".localized()
        
        serviceLbl.font = FontBook.Medium.of(size: 20)
        addCatLbl.font = FontBook.Regular.of(size: 12)
        
        
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getMyServices()
        let bottomViewBorder = CAShapeLayer()
        bottomViewBorder.strokeColor = UIColor.lightGray.cgColor
        bottomViewBorder.lineDashPattern = [2, 2]
        bottomViewBorder.frame = bottomAddView.bounds
        bottomViewBorder.fillColor = nil
        bottomViewBorder.path = UIBezierPath(rect: bottomAddView.bounds).cgPath
        bottomAddView.layer.addSublayer(bottomViewBorder)
    }
    /* func showAlert(title: String,msg : String)
     {
     let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
     
     // add an action (button)
     alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
     
     // show the alert
     self.present(alert, animated: true, completion: nil)
     }*/
    
    func getMyServices(){
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
        
        SwiftSpinner.show("Fetching your Services...".localized())
        let url = APIList().getUrlString(url: .VIEW_PROVIDER_CATEGORY)
        //        let url = "\(Constants.baseURL)/view_provider_category"
        Alamofire.request(url,method: .get, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("BOOKINGS JSON: \(json)") // serialized json response
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
                        self.categories = jsonResponse["category"].arrayValue
                        self.servicesCollectionView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            changeTintColor(imgPlus, arg: mycolor)
            //changeTintColor(editImage, arg: mycolor)
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
    @IBAction func addNewCategory(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryViewController") as! AddCategoryViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }else {
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            
            present(Dvc, animated: true, completion: nil)
        }
        
    }
    
    func didFinishSelectingCategories(selctedCategory : JSON)
    {
        print (selctedCategory)
        self.addService(service: selctedCategory)
        
    }
    
    
    func addService(service: JSON){
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
        
        let catId = service["category_id"].stringValue
        let subCatId = service["sub_category_id"].stringValue
        let quickpitch = service["quickpitch"].stringValue
        let priceperhour = service["priceperhour"].stringValue
        let experience = service["experience"].stringValue
        
        let params: Parameters = [
            "category_id": catId,
            "sub_category_id":subCatId,
            "quickpitch":quickpitch,
            "priceperhour":priceperhour,
            "experience":experience
        ]
        SwiftSpinner.show("Adding your Service...".localized())
        let url = APIList().getUrlString(url: .ADD_CATEGORY)
        //        let url = "\(Constants.baseURL)/add_category"
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
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        self.getMyServices()
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            changeTintColor(cell.editImage, arg: mycolor)
        }
        
        cell.categoryName.text = self.categories[indexPath.row]["category_name"].stringValue
        
        let service = "Service:".localized()
        
        let subCategory = "\(service) \(self.categories[indexPath.row]["sub_category_name"].stringValue)"
        let subCategoryRange = NSRange(location: 0, length: 9)
        let attributedString = NSMutableAttributedString(string: subCategory, attributes: nil)
        
        let color = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: subCategoryRange)
        cell.serviceName.attributedText = attributedString
        
        let exp = "Experience:".localized()
        
        let experience = "\(exp) \(self.categories[indexPath.row]["experience"].stringValue)"
        let experienceRange = NSRange(location: 0, length: 10)
        let experienceAttributedString = NSMutableAttributedString(string: experience, attributes: nil)
        experienceAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: experienceRange)
        cell.exprerience.attributedText = experienceAttributedString
        
        let price = "Price per hour:".localized()
        
        let priceperhour = "\(price) ₦\(self.categories[indexPath.row]["priceperhour"].stringValue)"
        let priceperhourRange = NSRange(location: 0, length: 15)
        let priceperhourAttributedString = NSMutableAttributedString(string: priceperhour, attributes: nil)
        priceperhourAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: priceperhourRange)
        cell.pricePerHour.attributedText = priceperhourAttributedString
        
        let pitch = "Quick pitch:".localized()
        
        let quickpitch = "\(pitch) \(self.categories[indexPath.row]["quickpitch"].stringValue)"
        let quickpitchRange = NSRange(location: 0, length: 12)
        let quickpitchAttributedString = NSMutableAttributedString(string: quickpitch, attributes: nil)
        quickpitchAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: quickpitchRange)
        cell.quickPitch.attributedText = quickpitchAttributedString
        cell.quickPitch.sizeToFit()
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(ServicesViewController.editButtonPressed(sender:)), for: .touchUpInside)
        return cell
        
    }
    
    @objc func editButtonPressed(sender: UIButton!){
        print(sender.tag)
        //        EditCategoryViewController
        if Reachability.isConnectedToNetwork() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditCategoryViewController") as! EditCategoryViewController
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            vc.serviceDictionary = self.categories[sender.tag].dictionaryValue
            self.present(vc, animated: true, completion: nil)
        }else {
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            
            present(Dvc, animated: true, completion: nil)
        }
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
