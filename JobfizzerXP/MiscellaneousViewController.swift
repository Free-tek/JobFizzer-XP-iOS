//
//  MiscellaneousViewController.swift
//  UberdooXP
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 Uberdoo. All rights reserved.
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

class MiscellaneousViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    

    

    
    @IBOutlet weak var miscellaneousTableView: UITableView!
    @IBOutlet weak var takedPhoto: UIImageView!
    
    
    
    @IBOutlet weak var takePhotoLbl: UILabel!
 
    @IBOutlet weak var submitLbl: UILabel!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var addMiscellaneousBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var skipLineView: UIView!
    
    
    var bookingDetails : [String:JSON]!
    var dataDict:[String:String] = [:]
    var dataArray:[[String:String]] = []
    var materialData:String = ""
    var lat = ""
    var log = ""
    
    var mycolor = UIColor()
    var addressString : String = ""
    var image:UIImage!
    var imageString = " "
    var count = 1
    
    @IBAction func skipBtn(_ sender: Any) {
        print("You've pressed cancel");
        self.finishJob()
        
    }
    
    
    @IBAction func takePhotoBtn(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .camera
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func uploadBtn(_ sender: Any) {
        fetchAllData()
        //uploadImage(img: image)
        
    }
    
    @IBAction func addMiscellaneousBtnClicked(_ sender: Any) {
        miscellaneousTableView.isHidden = false
        count = count+1
        addMiscellaneousBtn.setTitle("Add more", for: .normal)
        miscellaneousTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miscellaneousTableView.isHidden = true
        miscellaneousTableView.delegate = self
        miscellaneousTableView.dataSource = self
        miscellaneousTableView.separatorStyle = .none
        
        addMiscellaneousBtn.setTitle("Add miscellaneous", for: .normal)
        skipBtn.setTitle("Skip", for: .normal)
        submitLbl.text = "Submit"
        takePhotoLbl.text = "Take photo"
        
        
        
        lat = UserDefaults.standard.object(forKey:"lastKnownLatitude") as! String
        log = UserDefaults.standard.object(forKey:"lastKnownLongitude") as! String
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
            submitLbl.backgroundColor = mycolor
            skipBtn.setTitleColor(mycolor, for: .normal)
                skipLineView.backgroundColor = mycolor
            addMiscellaneousBtn.setTitleColor(mycolor, for: .normal)
            addMiscellaneousBtn.layer.borderWidth = 0.5
            addMiscellaneousBtn.layer.borderColor = mycolor.cgColor
            addMiscellaneousBtn.titleLabel?.textColor = mycolor
        }
    }
    @objc func removeMiscellaneous(value:UIButton){
        count = count-1
        print("tag",value.tag)
        
        var selectedIndexPath = IndexPath(item: value.tag, section: 0)
        var cell = miscellaneousTableView.cellForRow(at: selectedIndexPath) as! MiscellaneousTableViewCell
        cell.descriptionTf.text = ""
        cell.amountTf.text = ""
        miscellaneousTableView.deleteRows(at: [selectedIndexPath], with: .none)
        if(count == 1){
            addMiscellaneousBtn.setTitle("Add miscellaneous", for: .normal)
            miscellaneousTableView.isHidden = true
        }else{
            addMiscellaneousBtn.setTitle("Add more", for: .normal)
            miscellaneousTableView.isHidden = false
        }
        miscellaneousTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiscellaneousTableViewCell", for: indexPath) as! MiscellaneousTableViewCell
        cell.nameLbl.isHidden = true
        cell.amountLbl.isHidden = true
        cell.amountTf.isHidden = true
        cell.removeBtn.isHidden = true
        cell.currencyLbl.isHidden = true
        cell.descriptionTf.isHidden = true
        cell.removeImageView.isHidden = true
        cell.nameLine.isHidden = true
        cell.priceLine.isHidden = true
        cell.removeBtn.addTarget(self, action: #selector(removeMiscellaneous), for: .touchUpInside)
        print(indexPath.row)
        if(indexPath.row == 0){
            cell.nameLbl.isHidden = false
            cell.amountLbl.isHidden = false
        }else{
            cell.amountTf.isHidden = false
            cell.removeBtn.isHidden = false
            cell.currencyLbl.isHidden = false
            cell.descriptionTf.isHidden = false
            cell.removeImageView.isHidden = false
            cell.nameLine.isHidden = false
            cell.priceLine.isHidden = false
            cell.amountTf.delegate = self
            cell.descriptionTf.delegate = self
            cell.removeBtn.tag = indexPath.row
            
        }
        return cell
    }

    @objc func fetchAllData(){
       
        dataArray.removeAll()
        for i in 1..<count{
            let selectedIndexPath = IndexPath(item: i, section: 0)
            var cell = miscellaneousTableView.cellForRow(at: selectedIndexPath) as! MiscellaneousTableViewCell
            dataDict = [:]
            dataDict["material_name"] = cell.descriptionTf.text ?? ""
            dataDict["material_cost"] = cell.amountTf.text ?? ""
            dataArray.append(dataDict)
        }
        print(dataArray)
        materialData = json(from: dataArray) ?? ""
        if(image != nil){
           uploadImage(img: image)
        }else{
            self.finishJob()
        }
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        var selectedIndexPath = IndexPath(item: textField.tag, section: 0)
//
//        let selectedCell = miscellaneousTableView.cellForRow(at: selectedIndexPath) as! MiscellaneousTableViewCell
//            descriptionArray.append(textField.text ?? "")
//
//        print(descriptionArray,amountArray)
//    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        skipBtn.isHidden = true
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //uploadImage(img: image)
        takedPhoto.image = image
        picker.dismiss(animated: true)
       // submitBtn.isUserInteractionEnabled = true
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(img: UIImage)
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
        
        let url = "\(Constants.baseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
        //        let img = self.profilePicFld.backgroundImage(for: UIControlState.normal)
        print(url)
        let imagedata = UIImageJPEGRepresentation(img, 0.6)
        print("image data",img,imagedata)
        
        SwiftSpinner.show("Uploading".localized())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
                print("multipartFormData",multipartFormData)
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { (result) in
            
            switch result
            {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    print(jsonResponse)
                    self.imageString = jsonResponse["image"].stringValue
                    print("image String",self.imageString)
                    
                    
                    self.finishJob()
                    
                    print("Succesfully uploaded")
                    if let err = response.error
                    {
                        
                        SwiftSpinner.hide()
                        
                        print(err)
                        return
                    }
                }
            case .failure(let error):
                
                
                SwiftSpinner.hide()
                
                print("Error in upload: \(error.localizedDescription)")
            }
        })
        
    }
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func finishJob()
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
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        
        formatter.string(from: currentDateTime) // October 8, 2016 at 10:48:53 PM
        
        
        let bookingId = self.bookingDetails["id"]?.stringValue
        var booking = ""
        if SharedObject().hasData(value: bookingId){
            booking = bookingId!
        }
        var params: Parameters = [:]
        
        if(materialData != ""){
            params = [
                "id": booking,
                "end_image":imageString,
                "end_lat":lat,
                "end_long":log,
                "end_address":addressString,
                "end_time":currentDateTime,
                "material_cost": materialData
            ]
        }else{
            params = [
                "id": booking,
                "end_image":imageString,
                "end_lat":lat,
                "end_long":log,
                "end_address":addressString,
                "end_time":currentDateTime
            ]
        }
       
        
        
        print("Finish params = ", params)
        
        
        SwiftSpinner.show("Finishing the Job...".localized())
        let url = APIList().getUrlString(url: .FINISHJOB)
        //        let url = "\(Constants.baseURL)/completedjob"
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
                        self.showAlert(title: "Failed".localized(),msg: errorMessage)
                    }
                    else{
                        let stoaryboard = UIStoryboard.init(name: "Main", bundle: nil)
                        let vc = stoaryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
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
