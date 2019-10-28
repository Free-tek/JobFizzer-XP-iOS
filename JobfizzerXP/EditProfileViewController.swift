//
//  EditProfileViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 04/02/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import Nuke


protocol updateImageDelegate
{
    func updateImage()
}


class EditProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,OfflineViewControllerDelegate
{
    func tryAgain() {
        dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var titleLbl: UILabel!
     var imageclicked = true
    @IBOutlet weak var genderTopView: UIView!
    var genders = ["Male".localized(), "Female".localized(), "Other".localized()]
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var mobileNo: UITextField!
    @IBOutlet weak var dobTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var aboutYouTxt: UITextField!
    @IBOutlet weak var genderView: UIPickerView!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var updateDelegate: updateImageDelegate?
    var isback = false
    
    var imageName : String!
    var mobileNumber : String!
    var dob : String!
    var gender : String!
    var mycolor = UIColor()
//    @IBOutlet weak var aboutYouTxtFld: UITextField!
//    @IBOutlet weak var lastNameTxtFld: UITextField!
//    @IBOutlet weak var firstNameTxtFld: UITextField!
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ "
    let ACCEPTABLE_CHARACTERS1 = "0123456789+"
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLbl.text = "Edit Profile".localized()
        firstName.placeholder = "First name".localized()
        lastName.placeholder = "Last name".localized()
        mobileNo.placeholder = "Mobile number".localized()
        dobTxt.placeholder = "DOB".localized()
        genderTxt.placeholder = "Gender".localized()
        aboutYouTxt.placeholder = "About You".localized()
        btnSave.setTitle("SAVE".localized(), for: .normal)
    
        
        titleLbl.font = FontBook.Medium.of(size: 20)
        firstName.font = FontBook.Regular.of(size: 17)
        lastName.font = FontBook.Regular.of(size: 17)
        mobileNo.font = FontBook.Regular.of(size: 17)
        dobTxt.font = FontBook.Regular.of(size: 17)
        genderTxt.font = FontBook.Regular.of(size: 17)
        aboutYouTxt.font = FontBook.Regular.of(size: 17)        
        btnSave.titleLabel!.font = FontBook.Regular.of(size: 17)
        
        
        
        
        firstName.delegate = self
        lastName.delegate = self
        mobileNo.delegate = self
        aboutYouTxt.delegate = self
        
        firstName.keyboardType = .asciiCapable
        lastName.keyboardType = .asciiCapable
        aboutYouTxt.keyboardType = .asciiCapable
        if #available(iOS 10.0, *) {
            mobileNo.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }

        genderView.layer.shadowColor = UIColor.black.cgColor
        genderView.layer.shadowOpacity = 0.5
        genderView.layer.shadowOffset = CGSize(width: -1, height: 1)
        genderView.layer.shadowRadius = 1
        
        genderView.layer.shadowPath = UIBezierPath(rect: genderView.bounds).cgPath
        genderView.layer.shouldRasterize = true
        genderView.layer.cornerRadius = 10

        dobTxt.isUserInteractionEnabled = false
        
        genderTxt.text = genders[0]
        genderView.delegate = self
        genderView.dataSource = self
        
        genderView.isHidden = true
        genderTopView.isHidden = true;
        self.getProfile()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isback
        {
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                //            var color: UIColor? = nil
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                btnSave.backgroundColor = mycolor
                changeTintColor(profilePicture, arg: mycolor)
//                 self.profilePicture.sd_setImage(with: URL(string: Constants.PLACE_HOLDER_IMAGE_URL), placeholderImage: UIImage(named: ""))
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

    func getProfile()
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
        
        SwiftSpinner.show("Fetching Profile Details...".localized())
//        let url = "\(Constants.baseURL)/viewprofile"
        let url = APIList().getUrlString(url: .VIEWPROFILE)
        Alamofire.request(url,method: .get, headers:headers).responseJSON
        {
            response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value
                {
                    print("VIEW PROFILE JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "Unauthenticated" || jsonResponse["error"].stringValue == "true")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        self.firstName.text = jsonResponse["provider_details"]["first_name"].stringValue
                        self.lastName.text = jsonResponse["provider_details"]["last_name"].stringValue
                        self.mobileNo.text = jsonResponse["provider_details"]["mobile"].stringValue
                        self.dobTxt.text = jsonResponse["provider_details"]["dob"].stringValue
                        self.genderTxt.text = jsonResponse["provider_details"]["gender"].stringValue
                        self.aboutYouTxt.text = jsonResponse["provider_details"]["about"].stringValue

                        
                        if let image = jsonResponse["provider_details"]["image"].string{
                            self.imageName = image
                            if let imageUrl = URL.init(string: image) as URL!
                            {
                                Nuke.loadImage(with: imageUrl, into: self.profilePicture)
                                
                                
                            }
                        }
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
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    */
    
    @IBAction func profilePictureClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera".localized(), style: .default, handler: {
            action in
            
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .default, handler: {
            action in
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        isback = true
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicture.image = image
        imageclicked = false
        picker.dismiss(animated: true)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isback = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage()
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
        print(imageName)
        if imageclicked
        {
            print("Image is empty")
            self.setProfile()
        }
        else
        {
        let url = "\(Constants.baseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
        let img = self.profilePicture.image
        let imagedata = UIImageJPEGRepresentation(img!, 0.6)
        
        
        
        SwiftSpinner.show("Uploading Image".localized())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { (result) in
            print("result",result)
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    //                    print(jsonResponse)
                    let error = jsonResponse["error"].stringValue
                    self.imageName = jsonResponse["image"].stringValue
                    print("Succesfully uploaded")
                    self.setProfile()
                    if let err = response.error{
                        self.showAlert(title: "Oops".localized(), msg: "Something went wrong".localized())
                        print(err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        })
        }
        
    }
    
    @IBAction func savePressed(_ sender: Any)
    {
        if Reachability.isConnectedToNetwork() {
        
        let validationFailed = "Validation Failed".localized()
        
        if(firstName.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Enter First Name".localized())
        }
        else if (lastName.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Enter Last Name".localized())
        }
        else if (mobileNo.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Enter Mobile Number".localized())
        }
        else if(mobileNo.text!.count < 5)
        {
            self.showAlert(title: validationFailed, msg: "Mobile Number Should be minimum 5 digits".localized())
            
        }
        else if (genderTxt.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Enter Select Gender".localized())
        }
        else if (dobTxt.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Select DOB".localized())
        }
        else if (aboutYouTxt.text == "")
        {
            self.showAlert(title: validationFailed, msg: "Please Enter About You".localized())
        }
        else
        {
            self.uploadImage()
        }
/*        if(firstNameTxtFld.text != "")
        {
            if(lastNameTxtFld.text != "")
            {
                if(aboutYouTxtFld.text != "")
                {
                    self.uploadImage()
                }
                else{
                    self.showAlert(title: "Validation Failed", msg: "Invalid Phone Number")
                }
                
            }
            else{
                self.showAlert(title: "Validation Failed", msg: "Invalid Last Name")
            }
        }
        else{
            self.showAlert(title: "Validation Failed", msg: "Invalid First Name")
        }
        */
        }
        else {
            
            let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
            Dvc.modalTransitionStyle = .crossDissolve
            Dvc.delegate = self
            present(Dvc, animated: true, completion: nil)
            //            showAlert(title: "Oops".localized(), msg: "Please check the internet connection".localized())
        }
    }
    
    func setProfile()
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
        
        
        
        var params = Parameters()
        var image = ""
        if SharedObject().hasData(value: imageName)
        {
            image = imageName!
        }
        if SharedObject().hasData(value: self.imageName)
        {
            params = [
                "first_name": firstName.text!,
                "last_name": lastName.text!,
                "mobile": mobileNo.text!,
                "gender":genderTxt.text!,
                "dob":dobTxt.text!,
                "about":aboutYouTxt.text!,
                "image": image
            ]
        }
        else
        {
            
            params = [
                "first_name": firstName.text!,
                "last_name": lastName.text!,
                "mobile": mobileNo.text!,
                "gender":genderTxt.text!,
                "dob":dobTxt.text!,
                "about":aboutYouTxt.text!,
                "image": " "
            ]
        }
        
        
        
        print(params)
        SwiftSpinner.show("Updating Profile Details...".localized())
//        let url = "\(Constants.baseURL)/updateprofile"
        let url = APIList().getUrlString(url: .UPDATEPROFILE)
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("EDIT PROFILE JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "Unauthenticated")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else if (jsonResponse["error"].stringValue == "true")
                    {
                        let errorMessage = jsonResponse["error_message"].string
                        self.showAlert(title: "Oops".localized(), msg: errorMessage!)
                    }
                    else{
                        UserDefaults.standard.set(self.imageName, forKey: "image")
                        UserDefaults.standard.set(self.firstName.text, forKey: "first_name")
                        UserDefaults.standard.set(self.lastName.text, forKey: "last_name")
                        
                        self.updateDelegate?.updateImage()
                        
                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dobBtn(_ sender: Any)
    {
        DatePickerDialog().show("Select your DOB".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), datePickerMode: .date) {
            (date) -> Void in
            if let dt = date
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.dobTxt.text = formatter.string(from: dt)
            }
        }
    }
    
    
    @IBAction func genderBtn(_ sender: Any)
    {
        genderTopView.isHidden = false
        genderView.isHidden = false;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        genderTxt.text = genders[row]
        genderView.isHidden = true;
        genderTopView.isHidden = true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == firstName || textField == lastName )
        {
            
            //            let maxLength = 15
            //            let currentString: NSString = textField.text! as NSString
            //            let newString: NSString =
            //                currentString.replacingCharacters(in: range, with: string) as NSString
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if (string == filtered)
            {
                let maxLength = 15
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
                
                //                return newString.length <= maxLength
            }
           
            else {
                
                return false
            }
        }
        else if ( textField == mobileNo)
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if (string == filtered)
            {
                let maxLength = 15
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
                
                //                return newString.length <= maxLength
            }
                
            else {
                
                return false
            }
        }
        else if (textField == aboutYouTxt) {
            if Int(range.location) == 0 && (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
        }
      /*  if (textField == firstName || textField == lastName || textField == mobileNo)
        {
            let maxLength = 15
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }*/
        else
        {
            return true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.text = textField.text!.trimmingCharacters(in: .whitespaces)
    }

}
