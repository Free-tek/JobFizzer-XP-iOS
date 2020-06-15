//
//  SignupViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 04/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import Localize_Swift

class SignupViewController: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,TimeSelectionDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AddressSelectionDelegate,UpdateAddressDelegate,OfflineViewControllerDelegate {
   
    func updateAddress(Address1: String, Address2: String, state: String, Zipcode: String, City: String) {
        line1.text! = Address1
        cityFld.text! = Address2
        zipcodeFld.text! = Zipcode
        line2.text! = City
        stateFld.text! = state
    }
    
    func tryAgain() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var lblGeneral: UILabel!
    
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var generalLbl: UILabel!
    @IBOutlet weak var generalIcon: UIImageView!
    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var dobFld: UITextField!
    @IBOutlet weak var genderFld: UITextField!
    @IBOutlet weak var generalIndicator: UIImageView!
    
    
    @IBOutlet weak var addressIndicator: UIImageView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressIcon: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var line1: UITextField!
    @IBOutlet weak var line2: UITextField!
    @IBOutlet weak var cityFld: UITextField!
    @IBOutlet weak var stateFld: UITextField!
    @IBOutlet weak var zipcodeFld: UITextField!
    @IBOutlet var genderPicker: UIPickerView!

    var genders = ["Male".localized(), "Female".localized(), "Other".localized()]
    
    
    var DateDialog = DatePickerDialog()
    

    @IBOutlet weak var registerIndicator: UIImageView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var registerIcon: UIImageView!
    @IBOutlet weak var registerLbl: UILabel!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var phoneFld: UITextField!
    @IBOutlet weak var passwordFld: UITextField!
    @IBOutlet weak var confirmPasswordFld: UITextField!
    
    @IBOutlet weak var profileIndicator: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var workExperienceFld: UITextField!
    @IBOutlet weak var aboutYouFld: UITextField!
    @IBOutlet weak var profilePicFld: UIButton!
    
    @IBOutlet weak var categoryIndicator: UIImageView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var centerAddView: UIView!
    @IBOutlet weak var bottomAddView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var availableIndicator: UIImageView!
    @IBOutlet weak var availableView: UIView!
    @IBOutlet weak var availableIcon: UIImageView!
    @IBOutlet weak var availabelLbl: UILabel!
    
    @IBOutlet weak var mondayAddButton: UIButton!
    @IBOutlet weak var mondayLbl: UILabel!
    
    @IBOutlet weak var tuesdayAddButton: UIButton!
    @IBOutlet weak var tuesdayLbl: UILabel!
    
    @IBOutlet weak var wednesdayLbl: UILabel!
    @IBOutlet weak var wednesdayAddButton: UIButton!
    
    @IBOutlet weak var thursdayAddButton: UIButton!
    @IBOutlet weak var thursdayLbl: UILabel!
    
    @IBOutlet weak var btnGetaddressfrommap: UIButton!
    @IBOutlet weak var fridayAddButton: UIButton!
    @IBOutlet weak var fridayLbl: UILabel!
    
    @IBOutlet weak var saturdayAddButton: UIButton!
    @IBOutlet weak var saturdayLbl: UILabel!
    
    @IBOutlet weak var sundayAddButton: UIButton!
    @IBOutlet weak var sundayLbl: UILabel!
    
    @IBOutlet weak var lblbottomadd: UILabel!
    @IBOutlet weak var lblAddstat: UILabel!
    var monday : [JSON] = []
    var tuesday : [JSON] = []
    var wednesday : [JSON] = []
    var thursday : [JSON] = []
    var friday : [JSON] = []
    var saturday : [JSON] = []
    var sunday : [JSON] = []
  
    
    var categories : [JSON] = []
    var timeSlots : [JSON] = []
    
    var mycolor = UIColor()
    var imageString : String!
    
    
    @IBOutlet weak var btnNext: UIButton!
    
    
    @IBOutlet weak var btnAlreadyAcoount: UIButton!
    @IBOutlet weak var lblCreateAccount: UILabel!
    @IBOutlet weak var lblHello: UILabel!
    var firstNameValue : String!
    var lastNameValue : String!
    var genderValue : String!
    var addressLine1Value : String!
    var addressLine2Value : String!
    var cityValue : String!
    var stateValue : String!
    var zipcodeValue : String!
    var aboutValue : String!
    var workExperienceValue : String!
    var emailValue : String!
    var passwordValue : String!
    var mobileValue : String!
    var dobValue : String!
    var schedulesValue : String!
    var categoryValue : String!
    var isImageSelected = false
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ "
    let ACCEPTABLE_CHARACTERS2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
    let ACCEPTABLE_CHARACTERS1 = "0123456789+"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameFld.delegate = self
        lastNameFld.delegate = self
        dobFld.delegate = self
        phoneFld.delegate = self
        line1.delegate = self
        line2.delegate = self
        cityFld.delegate = self
        stateFld.delegate = self
        zipcodeFld.delegate = self
        emailFld.delegate = self
        workExperienceFld.delegate = self
        aboutYouFld.delegate = self
        firstNameFld.autocorrectionType = .no
        lastNameFld.autocorrectionType = .no
        emailFld.autocorrectionType = .no
        passwordFld.autocorrectionType = .no
        confirmPasswordFld.autocorrectionType = .no
        line1.autocorrectionType = .no
        line2.autocorrectionType = .no
        cityFld.autocorrectionType = .no
        stateFld.autocorrectionType = .no
        zipcodeFld.autocorrectionType = .no
        workExperienceFld.autocorrectionType = .no
        aboutYouFld.autocorrectionType = .no
        
        firstNameFld.keyboardType = .asciiCapable
        lastNameFld.keyboardType = .asciiCapable
        emailFld.keyboardType = .asciiCapable
        passwordFld.keyboardType = .asciiCapable
        confirmPasswordFld.keyboardType = .asciiCapable
        firstNameFld.keyboardType = .asciiCapable
        line1.keyboardType = .asciiCapable
        line2.keyboardType = .asciiCapable
        cityFld.keyboardType = .asciiCapable
        stateFld.keyboardType = .asciiCapable
        if #available(iOS 10.0, *) {
            zipcodeFld.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
        aboutYouFld.keyboardType = .asciiCapable
        workExperienceFld.keyboardType = .asciiCapable
        
    
//        changeFont()
        
        genderFld.delegate = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        profilePicFld.layer.cornerRadius = profilePicFld.frame.width/2
        profilePicFld.clipsToBounds = true
        
        generalLbl.text = "GENERAL".localized()
        addressLbl.text = "ADDRESS".localized()
        registerLbl.text = "REGISTER".localized()
        profileLbl.text = "PROFILE".localized()
        categoryLbl.text = "CATEGORY".localized()
//        picker.delegate = self
        emailFld.placeholder = "Email address".localized()
        phoneFld.placeholder = "Phone number".localized()
        passwordFld.placeholder = "Password".localized()
        confirmPasswordFld.placeholder = "Confirm Password".localized()
        line1.placeholder = "Address 1".localized()
        line2.placeholder = "Address 2".localized()
        cityFld.placeholder = "City".localized()
        stateFld.placeholder = "State/ province".localized()
        zipcodeFld.placeholder = "Zipcode/Postalcode".localized()
        
        firstNameFld.placeholder = "First Name".localized()
        lastNameFld.placeholder = "Last Name".localized()
        btnGetaddressfrommap.setTitle("Get Address from Map".localized(), for: .normal)
        dobFld.placeholder = "DOB".localized()
        genderFld.placeholder = "Gender".localized()
        workExperienceFld.placeholder = "Work experience".localized()
        aboutYouFld.placeholder = "About you".localized()
        lblAddstat.text = "ADD CATEGORY".localized()
        lblbottomadd.text = "ADD CATEGORY".localized()
        lblHello.text = "Hello!".localized()
        lblCreateAccount.text = "Create your account to continue".localized()
        
        btnAlreadyAcoount.setTitle("Already have an account?".localized(), for: .normal)
        
        generalLbl.font = FontBook.Medium.of(size: 13)
        addressLbl.font = FontBook.Medium.of(size: 13)
        registerLbl.font = FontBook.Medium.of(size: 13)
        profileLbl.font = FontBook.Medium.of(size: 13)
        categoryLbl.font = FontBook.Medium.of(size: 13)
        lblHello.font = FontBook.Medium.of(size: 34)
        lblCreateAccount.font = FontBook.Regular.of(size: 17)
        btnNext.titleLabel?.font = FontBook.Regular.of(size: 17)
        btnAlreadyAcoount.titleLabel?.font = FontBook.Medium.of(size: 15)
        
        emailFld.font = FontBook.Regular.of(size: 15)
        phoneFld.font = FontBook.Regular.of(size: 15)
        passwordFld.font = FontBook.Regular.of(size: 15)
        confirmPasswordFld.font = FontBook.Regular.of(size: 15)
        line1.font = FontBook.Regular.of(size: 15)
        line2.font = FontBook.Regular.of(size: 15)
        cityFld.font = FontBook.Regular.of(size: 15)
        stateFld.font = FontBook.Regular.of(size: 15)
        zipcodeFld.font = FontBook.Regular.of(size: 15)
        btnGetaddressfrommap.titleLabel?.font = FontBook.Regular.of(size: 14)
        firstNameFld.font = FontBook.Regular.of(size: 15)
        lastNameFld.font = FontBook.Regular.of(size: 15)
        dobFld.font = FontBook.Regular.of(size: 15)
        genderFld.font = FontBook.Regular.of(size: 15)
        workExperienceFld.font = FontBook.Regular.of(size: 15)
        aboutYouFld.font = FontBook.Regular.of(size: 15)
        lblAddstat.font = FontBook.Regular.of(size: 12)
        lblbottomadd.font = FontBook.Regular.of(size: 12)
        
        
        
//        changeFont()
        let latestPage = UserDefaults.standard.string(forKey: "signUpStatus")
        
        //genderFld.text = genders[0]
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.isHidden = true
        
        line2.text = ""
        if(latestPage == nil)
        {
            self.showGeneralPage()
        }
        else if(latestPage == "generalOver")
        {
            self.firstNameFld.text = UserDefaults.standard.string(forKey: "firstName")
            self.lastNameFld.text = UserDefaults.standard.string(forKey: "lastName")
            self.dobFld.text = UserDefaults.standard.string(forKey: "dob")
            self.genderFld.text = UserDefaults.standard.string(forKey: "gender")
            self.showAddressPage()
        }
        else if(latestPage == "addressOver")
        {
            self.firstNameFld.text = UserDefaults.standard.string(forKey: "firstName")
            self.lastNameFld.text = UserDefaults.standard.string(forKey: "lastName")
            self.dobFld.text = UserDefaults.standard.string(forKey: "dob")
            self.genderFld.text = UserDefaults.standard.string(forKey: "gender")
            self.line1.text = UserDefaults.standard.string(forKey: "line1")
            self.line2.text = UserDefaults.standard.string(forKey: "line2")
            self.cityFld.text = UserDefaults.standard.string(forKey: "city")
            self.stateFld.text = UserDefaults.standard.string(forKey: "state")
            self.zipcodeFld.text = UserDefaults.standard.string(forKey: "zipcode")
            
            self.showRegisterPage()
        }
        else if(latestPage == "registerOver")
        {
            self.firstNameFld.text = UserDefaults.standard.string(forKey: "firstName")
            self.lastNameFld.text = UserDefaults.standard.string(forKey: "lastName")
            self.dobFld.text = UserDefaults.standard.string(forKey: "dob")
            self.genderFld.text = UserDefaults.standard.string(forKey: "gender")
            self.line1.text = UserDefaults.standard.string(forKey: "line1")
            self.line2.text = UserDefaults.standard.string(forKey: "line2")
            self.cityFld.text = UserDefaults.standard.string(forKey: "city")
            self.stateFld.text = UserDefaults.standard.string(forKey: "state")
            self.zipcodeFld.text = UserDefaults.standard.string(forKey: "zipcode")
            self.emailFld.text = UserDefaults.standard.string(forKey: "email")
            self.phoneFld.text = UserDefaults.standard.string(forKey: "phone")
            self.passwordFld.text = UserDefaults.standard.string(forKey: "password")
            self.confirmPasswordFld.text = UserDefaults.standard.string(forKey: "password")
            
            self.showProfilePage()
        }
        else if(latestPage == "profileOver")
        {
            self.firstNameFld.text = UserDefaults.standard.string(forKey: "firstName")
            self.lastNameFld.text = UserDefaults.standard.string(forKey: "lastName")
            self.dobFld.text = UserDefaults.standard.string(forKey: "dob")
            self.genderFld.text = UserDefaults.standard.string(forKey: "gender")
            self.line1.text = UserDefaults.standard.string(forKey: "line1")
            self.line2.text = UserDefaults.standard.string(forKey: "line2")
            self.cityFld.text = UserDefaults.standard.string(forKey: "city")
            self.stateFld.text = UserDefaults.standard.string(forKey: "state")
            self.zipcodeFld.text = UserDefaults.standard.string(forKey: "zipcode")
            self.emailFld.text = UserDefaults.standard.string(forKey: "email")
            self.phoneFld.text = UserDefaults.standard.string(forKey: "phone")
            self.passwordFld.text = UserDefaults.standard.string(forKey: "password")
            self.confirmPasswordFld.text = UserDefaults.standard.string(forKey: "password")
            
            self.workExperienceFld.text = UserDefaults.standard.string(forKey: "workexperience")
            self.aboutYouFld.text = UserDefaults.standard.string(forKey: "aboutyou")
//            if let myEncodedImageData = UserDefaults.standard.object(forKey: "image") as? Data {
//                let image = UIImage(data: myEncodedImageData )
//                self.profilePicFld.setBackgroundImage(image, for: UIControlState.normal)
//            }
            
            self.showCategoryPage()
        }
/*        else if(latestPage == "categoryOver")
        {
            self.firstNameFld.text = UserDefaults.standard.string(forKey: "firstName")
            self.lastNameFld.text = UserDefaults.standard.string(forKey: "lastName")
            self.dobFld.text = UserDefaults.standard.string(forKey: "dob")
            self.genderFld.text = UserDefaults.standard.string(forKey: "gender")
            self.line1.text = UserDefaults.standard.string(forKey: "line1")
            self.line2.text = UserDefaults.standard.string(forKey: "line2")
            self.cityFld.text = UserDefaults.standard.string(forKey: "city")
            self.stateFld.text = UserDefaults.standard.string(forKey: "state")
            self.zipcodeFld.text = UserDefaults.standard.string(forKey: "zipcode")
            self.emailFld.text = UserDefaults.standard.string(forKey: "email")
            self.phoneFld.text = UserDefaults.standard.string(forKey: "phone")
            self.passwordFld.text = UserDefaults.standard.string(forKey: "password")
            self.confirmPasswordFld.text = UserDefaults.standard.string(forKey: "password")
            
            self.workExperienceFld.text = UserDefaults.standard.string(forKey: "workexperience")
            self.aboutYouFld.text = UserDefaults.standard.string(forKey: "aboutyou")
            
//            self.categories = UserDefaults.standard.object(forKey: "categories") as! [JSON]
            self.categoryCollectionView.reloadData()

            self.showAvailabilityPage()
        }*/
        if(Constants.timeSlots.count > 0)
        {
        for i in 0 ... Constants.timeSlots.count-1{
            for dayOfTheWeek in 0 ... 6{
                var day:JSON = JSON.init()
                switch(dayOfTheWeek){
                case 0:
                    day["days"].stringValue = "Mon"
                    break
                case 1:
                    day["days"].stringValue = "Tue"
                    break
                case 2:
                    day["days"].stringValue = "Wed"
                    break
                case 3:
                    day["days"].stringValue = "Thu"
                    break
                case 4:
                    day["days"].stringValue = "Fri"
                    break
                case 5:
                    day["days"].stringValue = "Sat"
                    break
                case 6:
                    day["days"].stringValue = "Sun"
                    break
                default:
                    day["days"].stringValue = "Sun"
                }
                
                day["status"].stringValue = "1"
                day["time_Slots_id"].stringValue = Constants.timeSlots[i]["id"].stringValue
                self.timeSlots.append(day)
            }
        }
    }
        print(self.timeSlots)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
             mondayAddButton.titleLabel?.textColor = mycolor
             tuesdayAddButton.titleLabel?.textColor = mycolor
             wednesdayAddButton.titleLabel?.textColor = mycolor
             thursdayAddButton.titleLabel?.textColor = mycolor
             fridayAddButton.titleLabel?.textColor = mycolor
             saturdayAddButton.titleLabel?.textColor = mycolor
             sundayAddButton.titleLabel?.textColor = mycolor
        }
    }
    @IBAction func chooseProfilePicture(_ sender: Any) {
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePicFld.setBackgroundImage(image, for: UIControlState.normal)
        isImageSelected = true
        picker.dismiss(animated: true)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let centerViewBorder = CAShapeLayer()
        centerViewBorder.strokeColor = UIColor.lightGray.cgColor
        centerViewBorder.lineDashPattern = [2, 2]
        centerViewBorder.frame = centerAddView.bounds
        centerViewBorder.fillColor = nil
        centerViewBorder.path = UIBezierPath(rect: centerAddView.bounds).cgPath
        centerAddView.layer.addSublayer(centerViewBorder)
        
        let bottomViewBorder = CAShapeLayer()
        bottomViewBorder.strokeColor = UIColor.lightGray.cgColor
        bottomViewBorder.lineDashPattern = [2, 2]
        bottomViewBorder.frame = bottomAddView.bounds
        bottomViewBorder.fillColor = nil
        bottomViewBorder.path = UIBezierPath(rect: bottomAddView.bounds).cgPath
        bottomAddView.layer.addSublayer(bottomViewBorder)
        bottomAddView.isHidden = false
        self.categoryCollectionView.isHidden = false

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
        genderFld.text = genders[row]
        genderPicker.isHidden = true;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func genderFieldPressed(_ sender: Any) {
        genderPicker.isHidden = false
    }
    
    @IBAction func dobFieldPressed(_ sender: Any)
    {
        
        if self.dobFld.text != ""
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            let date = formatter.date(from: self.dobFld.text!)!

//            DateDialog.datePicker.setDate(date, animated: false)
            
             let calendar = Calendar(identifier: .gregorian)
             var comps = DateComponents()
             comps.year = -18
             let maxDate = calendar.date(byAdding: comps, to: Date())
            
             DateDialog.show("Select your DOB".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), defaultDate: date, minimumDate: nil, maximumDate: maxDate, datePickerMode: .date)
             {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.dobFld.text = formatter.string(from: dt)
                }
            }
        }
        else
        {
            DateDialog.show("Select your DOB".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.dobFld.text = formatter.string(from: dt)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        let service = "Service:".localized()
        let Experienc = "Experience:".localized()
        let Priceprhr = "Price per hour:".localized()
        let Quick = "Quick pitch:".localized()
        cell.categoryName.font = FontBook.Regular.of(size: 12)
        cell.serviceName.font = FontBook.Regular.of(size: 12)
        cell.quickPitch.font = FontBook.Regular.of(size: 12)
        cell.exprerience.font = FontBook.Regular.of(size: 12)
        cell.pricePerHour.font = FontBook.Regular.of(size: 12)
    
        cell.categoryName.text = self.categories[indexPath.row]["categoryName"].stringValue
        let subCategory = "\(service) \(self.categories[indexPath.row]["subCategoryName"].stringValue)"
        let subCategoryRange = NSRange(location: 0, length: 9)
        let attributedString = NSMutableAttributedString(string: subCategory, attributes: nil)
        
        let color = UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: subCategoryRange)
        cell.serviceName.attributedText = attributedString

        let experience = "\(Experienc) \(self.categories[indexPath.row]["experience"].stringValue)"
        let experienceRange = NSRange(location: 0, length: 10)
        let experienceAttributedString = NSMutableAttributedString(string: experience, attributes: nil)
        experienceAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: experienceRange)
        cell.exprerience.attributedText = experienceAttributedString
       
        let priceperhour = "\(Priceprhr) ₦\(self.categories[indexPath.row]["priceperhour"].stringValue)"
        let priceperhourRange = NSRange(location: 0, length: 15)
        let priceperhourAttributedString = NSMutableAttributedString(string: priceperhour, attributes: nil)
        priceperhourAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: priceperhourRange)
        cell.pricePerHour.attributedText = priceperhourAttributedString
        
        let quickpitch = "\(Quick) \(self.categories[indexPath.row]["quickpitch"].stringValue)"
        let quickpitchRange = NSRange(location: 0, length: 12)
        let quickpitchAttributedString = NSMutableAttributedString(string: quickpitch, attributes: nil)
        quickpitchAttributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: quickpitchRange)
        cell.quickPitch.attributedText = quickpitchAttributedString
        cell.quickPitch.sizeToFit()
        
        return cell
        
    }
    
    @IBAction func addTime(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectTimeSlotViewController") as! SelectTimeSlotViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.forDay = sender.tag
        switch sender.tag{
        case 0:
            vc.daysData = monday
            break;
        case 1:
            vc.daysData = tuesday
            break;
        case 2:
            vc.daysData = wednesday
            break;
        case 3:
            vc.daysData = thursday
            break;
        case 4:
            vc.daysData = friday
            break;
        case 5:
            vc.daysData = saturday
            break;
        case 6:
            vc.daysData = sunday
            break;
        default:
            vc.daysData = monday
            break;
        }
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func didFinishSelectingTime(slotsData: [JSON], dayOfTheWeek : Int) {
        switch dayOfTheWeek {
        case 0:
            monday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(monday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(monday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            mondayLbl.text = displayString
            if(mondayLbl.text!.count > 0)
            {
                self.mondayAddButton.titleLabel?.text = ""
            }
            
        case 1:
            tuesday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(tuesday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(tuesday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            tuesdayLbl.text = displayString
            if(tuesdayLbl.text!.count > 0)
            {
                self.tuesdayAddButton.titleLabel?.text = ""
            }
        case 2:
            wednesday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(wednesday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(wednesday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            wednesdayLbl.text = displayString
            if(wednesdayLbl.text!.count > 0)
            {
                self.wednesdayAddButton.titleLabel?.text = ""
            }
            
        case 3:
            thursday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(thursday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(thursday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            thursdayLbl.text = displayString
            if(thursdayLbl.text!.count > 0)
            {
                self.thursdayAddButton.titleLabel?.text = ""
            }
        case 4:
            friday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(friday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(friday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            fridayLbl.text = displayString
            if(fridayLbl.text!.count > 0)
            {
                self.fridayAddButton.titleLabel?.text = ""
            }
        case 5:
            saturday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(saturday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(saturday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            saturdayLbl.text = displayString
            if(saturdayLbl.text!.count > 0)
            {
                self.saturdayAddButton.titleLabel?.text = ""
            }
            
        case 6:
            sunday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(sunday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(sunday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            sundayLbl.text = displayString
            if(sundayLbl.text!.count > 0)
            {
                self.sundayAddButton.titleLabel?.text = ""
            }
            
        default:
            monday = slotsData
            
            var displayString = ""
            for i in 0 ... Constants.timeSlots.count-1
            {
                if(displayString == "")
                {
                    if(monday[i]["status"] == "1"){
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                else{
                    
                    if(monday[i]["status"] == "1"){
                        displayString.append(", ")
                        let currentTimeSlot = Constants.timeSlots[i]["timing"].stringValue
                        displayString.append(currentTimeSlot)
                    }
                }
                let slotId = slotsData[i]["time_Slots_id"].stringValue
                let status = slotsData[i]["status"].stringValue
                self.changeStatus(timeSlotId: slotId, dayOfTheWeek: dayOfTheWeek, status: status)
            }
            
            mondayLbl.text = displayString
            if(mondayLbl.text!.count > 0)
            {
                self.mondayAddButton.titleLabel?.text = ""
            }
        }
        
    }
    
    
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }*/
    
    func isFirstPageValid() -> (status : Bool, message : String){
        
        if(firstNameFld.text!.count == 0)
        {
            return (false,"First Name Required".localized())
        }
        else if(lastNameFld.text!.count == 0)
        {
            return (false,"Last Name Required".localized())
        }
        else if(dobFld.text!.count == 0)
        {
            return (false,"DOB Required".localized())
        }
        else if(genderFld.text!.count == 0)
        {
            return (false,"Gender Required".localized())
        }
        else{
            return (true,"")
        }
    }
    
    
    
    
    func isAddressPageValid() -> (status : Bool, message : String){
        if(line1.text!.count == 0)
        {
            return (false,"Address Line1 Required".localized())
        }
        else  if(line2.text!.count == 0)
        {
            return (false,"Address Line2 Required".localized())
        }
        else if(cityFld.text!.count == 0)
        {
            return (false,"City Required".localized())
        }
        else if(stateFld.text!.count == 0)
        {
            return (false,"State Required".localized())
        }
        else if(zipcodeFld.text!.count == 0)
        {
            return (false,"Zipcode Required".localized())
        }
        else{
            return (true,"")
        }
    }
    
    func isRegisterPageValid() -> (status : Bool, message : String){
        let email = validateEmail(enteredEmail: emailFld.text!)
        if(emailFld.text!.count == 0)
        {
            return (false,"Email Required".localized())
        }
        else if (email == false){
            return (false,"Enter Valid Mail Id".localized())
        }
        else if(phoneFld.text!.count == 0)
        {
            return (false,"Mobile Number Required".localized())
        }
        else if(phoneFld.text!.count < 5)
        {
            return (false,"Mobile Number Should be minimum 5 digits".localized())
        }
        else if(passwordFld.text!.count == 0)
        {
            return (false,"Password Required".localized())
        }
        else if (passwordFld.text!.count < 6){
            return (false, "Password Should be minimum 6 characters".localized())
        }
        else if(confirmPasswordFld.text!.count == 0)
        {
            return (false,"Confirm Password Required".localized())
        }
        else if(passwordFld.text! != confirmPasswordFld.text!)
        {
            return (false,"Passwords do not match".localized())
        }
        else{
            return (true,"")
        }
    }
    
    func isProfilePageValid() -> (status : Bool, message : String){
        if(workExperienceFld.text!.count == 0)
        {
            return (false,"Work Experience Required".localized())
        }
        else if(aboutYouFld.text!.count == 0)
        {
            return (false,"About You Required".localized())
        }
        else if(!isImageSelected){
            return (false,"Image Required".localized())
        }
        else{
            return (true,"")
        }
    }
    
    func isCategoryPageValid() -> (status : Bool, message : String){
        
        if(categories.count == 0)
        {
            return (false,"Select atleast one category".localized())
        }
        else{
            return (true,"")
        }
        
    }
    
    func changeStatus(timeSlotId: String, dayOfTheWeek: Int, status: String){
        var count = 0;
        for i in 0 ... Constants.timeSlots.count-1{
            for dotw in 0 ... 6{
                if(Constants.timeSlots[i]["id"].stringValue == timeSlotId && dotw == dayOfTheWeek){
                    self.timeSlots[count]["status"].stringValue = status
                }
                count = count + 1
            }
        }
        print(self.timeSlots)
    }
    
    func isAvailabilityPageValid() -> (status : Bool, message : String){
        
        if((mondayLbl.text!.count == 0) && (tuesdayLbl.text!.count == 0) && (wednesdayLbl.text!.count == 0) && (thursdayLbl.text!.count == 0) && (fridayLbl.text!.count == 0) && (saturdayLbl.text!.count == 0) && (sundayLbl.text!.count == 0))
        {
            return (false,"Add your availability".localized())
        }
        else
        {
            return (true,"")
        }
            
    }
    
    func showGeneralPage(){
        btnNext.setTitle("NEXT".localized(), for: .normal)
        generalIndicator.isHidden = false
        addressIndicator.isHidden = true
        registerIndicator.isHidden = true
        profileIndicator.isHidden = true
        categoryIndicator.isHidden = true
        availableIndicator.isHidden = true
        
        generalView.isHidden = false
        addressView.isHidden = true
        registerView.isHidden = true
        profileView.isHidden = true
        categoryView.isHidden = true
        availableView.isHidden = true
        
        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
    }
    
    
    func showAvailabilityPage(){
        btnNext.setTitle("NEXT".localized(), for: .normal)
        generalIndicator.isHidden = true
        addressIndicator.isHidden = true
        registerIndicator.isHidden = true
        profileIndicator.isHidden = true
        categoryIndicator.isHidden = true
        availableIndicator.isHidden = false
        
        generalView.isHidden = true
        addressView.isHidden = true
        registerView.isHidden = true
        profileView.isHidden = true
        categoryView.isHidden = true
        availableView.isHidden = false
        
        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
        addressLbl.textColor = UIColor.white
        addressIcon.alpha = 1
        registerLbl.textColor = UIColor.white
        registerIcon.alpha = 1
        profileLbl.textColor = UIColor.white
        profileIcon.alpha = 1
        categoryLbl.textColor = UIColor.white
        categoryIcon.alpha = 1
        availabelLbl.textColor = UIColor.white
        availableIcon.alpha = 1
    }
    
    func showCategoryPage(){
        btnNext.setTitle("FINISH".localized(), for: .normal)
        generalIndicator.isHidden = true
        addressIndicator.isHidden = true
        registerIndicator.isHidden = true
        profileIndicator.isHidden = true
        categoryIndicator.isHidden = false
        availableIndicator.isHidden = true
        
        generalView.isHidden = true
        addressView.isHidden = true
        registerView.isHidden = true
        profileView.isHidden = true
        categoryView.isHidden = false
        availableView.isHidden = true
        
        self.categoryCollectionView.isHidden = false
        self.centerAddView.isHidden = true
        self.bottomAddView.isHidden = false
        
        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
        addressLbl.textColor = UIColor.white
        addressIcon.alpha = 1
        registerLbl.textColor = UIColor.white
        registerIcon.alpha = 1
        profileLbl.textColor = UIColor.white
        profileIcon.alpha = 1
        categoryLbl.textColor = UIColor.white
        categoryIcon.alpha = 1

    }
    func showProfilePage(){
        btnNext.setTitle("NEXT".localized(), for: .normal)
        generalIndicator.isHidden = true
        addressIndicator.isHidden = true
        registerIndicator.isHidden = true
        profileIndicator.isHidden = false
        categoryIndicator.isHidden = true
        availableIndicator.isHidden = true
        
        generalView.isHidden = true
        addressView.isHidden = true
        registerView.isHidden = true
        profileView.isHidden = false
        categoryView.isHidden = true
        availableView.isHidden = true
        
        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
        addressLbl.textColor = UIColor.white
        addressIcon.alpha = 1
        registerLbl.textColor = UIColor.white
        registerIcon.alpha = 1
        profileLbl.textColor = UIColor.white
        profileIcon.alpha = 1
    }
    
    func showRegisterPage(){
        btnNext.setTitle("NEXT".localized(), for: .normal)
        generalIndicator.isHidden = true
        addressIndicator.isHidden = true
        registerIndicator.isHidden = false
        profileIndicator.isHidden = true
        categoryIndicator.isHidden = true
        availableIndicator.isHidden = true
        
        generalView.isHidden = true
        addressView.isHidden = true
        registerView.isHidden = false
        profileView.isHidden = true
        categoryView.isHidden = true
        availableView.isHidden = true

        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
        addressLbl.textColor = UIColor.white
        addressIcon.alpha = 1
        registerLbl.textColor = UIColor.white
        registerIcon.alpha = 1

    }
    
    func showAddressPage(){
        btnNext.setTitle("NEXT".localized(), for: .normal)
        generalIndicator.isHidden = true
        addressIndicator.isHidden = false
        registerIndicator.isHidden = true
        profileIndicator.isHidden = true
        categoryIndicator.isHidden = true
        availableIndicator.isHidden = true
        
        generalView.isHidden = true
        addressView.isHidden = false
        registerView.isHidden = true
        profileView.isHidden = true
        categoryView.isHidden = true
        availableView.isHidden = true
        
        generalLbl.textColor = UIColor.white
        generalIcon.alpha = 1
        addressLbl.textColor = UIColor.white
        addressIcon.alpha = 1
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        
        if(generalView.isHidden == false)
        {
            let validation = isFirstPageValid()
            if(!validation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: validation.message)
            }
            else{
                UserDefaults.standard.set("generalOver", forKey: "signUpStatus")
                UserDefaults.standard.set(firstNameFld.text!, forKey: "firstName")
                UserDefaults.standard.set(lastNameFld.text!, forKey: "lastName")
                UserDefaults.standard.set(dobFld.text!, forKey: "dob")
                UserDefaults.standard.set(genderFld.text!, forKey: "gender")
                self.showAddressPage()
            }
            
        }
        else if(addressView.isHidden == false)
        {
            let validation = isAddressPageValid()
            if(!validation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: validation.message)
            }
            else{
                UserDefaults.standard.set("addressOver", forKey: "signUpStatus")
                UserDefaults.standard.set(line1.text!, forKey: "line1")
                UserDefaults.standard.set(line2.text!, forKey: "line2")
                UserDefaults.standard.set(cityFld.text!, forKey: "city")
                UserDefaults.standard.set(stateFld.text!, forKey: "state")
                UserDefaults.standard.set(zipcodeFld.text!, forKey: "zipcode")
                self.showRegisterPage()
            }

        }
        else if(registerView.isHidden == false)
        {
            let validation = isRegisterPageValid()
            if(!validation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: validation.message)
            }
            else{
                UserDefaults.standard.set("registerOver", forKey: "signUpStatus")
                UserDefaults.standard.set(emailFld.text!, forKey: "email")
                UserDefaults.standard.set(phoneFld.text!, forKey: "phone")
                UserDefaults.standard.set(passwordFld.text!, forKey: "password")

                self.showProfilePage()
            }
        }
        else if(profileView.isHidden == false)
        {
            let validation = isProfilePageValid()
            if(!validation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: validation.message)
            }
            else{
                UserDefaults.standard.set("profileOver", forKey: "signUpStatus")
                UserDefaults.standard.set(workExperienceFld.text!, forKey: "workexperience")
                UserDefaults.standard.set(aboutYouFld.text!, forKey: "aboutyou")

                self.showCategoryPage()
            }
        }
        else if(categoryView.isHidden == false)
        {
            if Reachability.isConnectedToNetwork()
            {
//            let validation = isCategoryPageValid()
            let firstPageValidation = isFirstPageValid()
            let addressPageValidation = isAddressPageValid()
            let registerPageValidation = isRegisterPageValid()
            let profilePageValidation = isProfilePageValid()
            let categoryPageValidation = isCategoryPageValid()
            if(!firstPageValidation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: firstPageValidation.message)
            }
            else if(!addressPageValidation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: addressPageValidation.message)
            }
            else if(!registerPageValidation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: registerPageValidation.message)
            }
            else if(!profilePageValidation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: profilePageValidation.message)
            }
            else if(!categoryPageValidation.status)
            {
                self.showAlert(title: "Validation Failed".localized(), msg: categoryPageValidation.message)
            }else{
//                UserDefaults.standard.set("categoryOver", forKey: "signUpStatus")
//                UserDefaults.standard.set(self.categories, forKey: "categories")
//                self.showAvailabilityPage()
                
                self.uploadImage()
               
                }
            }
            else
            {
                let stoaryBoard = UIStoryboard.init(name: "SecondStoryboard", bundle: nil)
                let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "OfflineViewController")as! OfflineViewController
                Dvc.modalTransitionStyle = .crossDissolve
                Dvc.delegate = self
                present(Dvc, animated: true, completion: nil)
            }
            
        }
            
/*
        else if(availableView.isHidden == false)
        {
         
            let validation = isAvailabilityPageValid()
            if(!validation.status)
            {
                self.showAlert(title: "Validation Failed", msg: validation.message)
            }
            else{
                
//                self.signUp()
                self.uploadImage()
            }
            
        }
*/
        
    }
    
    @IBAction func addNewCategory(_ sender: Any)
    {
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
        self.categories.append(selctedCategory)
        print(self.categories)
        if(categories.count > 0)
        {
            self.categoryCollectionView.isHidden = false
            self.centerAddView.isHidden = true
            self.bottomAddView.isHidden = false
        }
        else{
            self.categoryCollectionView.isHidden = true
            self.bottomAddView.isHidden = false
            self.centerAddView.isHidden = true
        }
        self.categoryCollectionView.reloadData()
    }
    
    
    @IBAction func selectTab(_ sender: UIButton) {
        print(sender.tag)
        switch(sender.tag){
        case 0:
            showGeneralPage()
            break
        case 1:
            if(addressIcon.alpha == 1)
            {
                showAddressPage()
            }
            break
        case 2:
            if(registerIcon.alpha == 1)
            {
                showRegisterPage()
            }
            break
        case 3:
            if(profileIcon.alpha == 1)
            {
                showProfilePage()
            }
            break
        case 4:
            if(categoryIcon.alpha == 1)
            {
                showCategoryPage()
            }
            break
        case 5:
            if(availableIcon.alpha == 1)
            {
                showAvailabilityPage()
            }
            break
        default:
            showGeneralPage()
            break
        }
    }
    @IBAction func goToSignInPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func signUp(){
        
        /*first_name:sakthi
        last_name:vignesh
        gender:M
        address1:kjsadasl
        address2:sadas
        city:chennai
        state:tamilnadku
        zipcode:600037
        about:akjhdjakjsdaksdaksda
        workexperience:2 yrs
        email:providersakthi@gmail.com
        password:123456
        mobile:8527449263
        dob:1994-01-27*/
        var gender : String!
        if(genderFld.text == "Male".localized())
        {
            gender = "Male".localized()
        }
        else if(genderFld.text == "Female".localized())
        {
            gender = "Female".localized()
        }
        else{
            gender = "Other".localized()
        }
        
        let category = String(describing: self.categories)
        let schedule = String(describing: self.timeSlots)
//        let Dict1 : NSDictionary = ["time_Slots_id": 1,"days": "Mon","status": "1"]
//         let Dict2 : NSDictionary = ["time_Slots_id": 1,"days": "Tue","status": "1"]
//         let Dict3 : NSDictionary = ["time_Slots_id": 1,"days": "Wed","status": "1"]
//         let Dict4 : NSDictionary = ["time_Slots_id": 1,"days": "Thu","status": "1"]
//         let Dict5 : NSDictionary = ["time_Slots_id": 1,"days": "Fri","status": "1"]
//         let Dict6 : NSDictionary = ["time_Slots_id": 1,"days": "Sat","status": "1"]
//         let Dict7 : NSDictionary = ["time_Slots_id": 1,"days": "Sun","status": "1"]
//        let Dict11 : NSDictionary = ["time_Slots_id": 10,"days": "Mon","status": "1"]
//        let Dict12 : NSDictionary = ["time_Slots_id": 10,"days": "Tue","status": "1"]
//        let Dict13 : NSDictionary = ["time_Slots_id": 10,"days": "Wed","status": "1"]
//        let Dict14 : NSDictionary = ["time_Slots_id": 10,"days": "Thu","status": "1"]
//        let Dict15 : NSDictionary = ["time_Slots_id": 10,"days": "Fri","status": "1"]
//        let Dict16 : NSDictionary = ["time_Slots_id": 10,"days": "Sat","status": "1"]
//        let Dict17 : NSDictionary = ["time_Slots_id": 10,"days": "Sun","status": "1"]
//        let Dict21 : NSDictionary = ["time_Slots_id": 11,"days": "Mon","status": "1"]
//        let Dict22 : NSDictionary = ["time_Slots_id": 11,"days": "Tue","status": "1"]
//        let Dict23 : NSDictionary = ["time_Slots_id": 11,"days": "Wed","status": "1"]
//        let Dict24 : NSDictionary = ["time_Slots_id": 11,"days": "Thu","status": "1"]
//        let Dict25 : NSDictionary = ["time_Slots_id": 11,"days": "Fri","status": "1"]
//        let Dict26 : NSDictionary = ["time_Slots_id": 11,"days": "Sat","status": "1"]
//        let Dict27 : NSDictionary = ["time_Slots_id": 11,"days": "Sun","status": "1"]
//        let Dict31 : NSDictionary = ["time_Slots_id": 12,"days": "Mon","status": "1"]
//        let Dict32 : NSDictionary = ["time_Slots_id": 12,"days": "Tue","status": "1"]
//        let Dict33 : NSDictionary = ["time_Slots_id": 12,"days": "Wed","status": "1"]
//        let Dict34 : NSDictionary = ["time_Slots_id": 12,"days": "Thu","status": "1"]
//        let Dict35 : NSDictionary = ["time_Slots_id": 12,"days": "Fri","status": "1"]
//        let Dict36 : NSDictionary = ["time_Slots_id": 12,"days": "Sat","status": "1"]
//        let Dict37 : NSDictionary = ["time_Slots_id": 12,"days": "Sun","status": "1"]
//        let Dict41 : NSDictionary = ["time_Slots_id": 13,"days": "Mon","status": "1"]
//        let Dict42 : NSDictionary = ["time_Slots_id": 13,"days": "Tue","status": "1"]
//        let Dict43 : NSDictionary = ["time_Slots_id": 13,"days": "Wed","status": "1"]
//        let Dict44 : NSDictionary = ["time_Slots_id": 13,"days": "Thu","status": "1"]
//        let Dict45 : NSDictionary = ["time_Slots_id": 13,"days": "Fri","status": "1"]
//        let Dict46 : NSDictionary = ["time_Slots_id": 13,"days": "Sat","status": "1"]
//        let Dict47 : NSDictionary = ["time_Slots_id": 13,"days": "Sun","status": "1"]
//        let Dict51 : NSDictionary = ["time_Slots_id": 14,"days": "Mon","status": "1"]
//        let Dict52 : NSDictionary = ["time_Slots_id": 14,"days": "Tue","status": "1"]
//        let Dict53 : NSDictionary = ["time_Slots_id": 14,"days": "Wed","status": "1"]
//        let Dict54 : NSDictionary = ["time_Slots_id": 14,"days": "Thu","status": "1"]
//        let Dict55 : NSDictionary = ["time_Slots_id": 14,"days": "Fri","status": "1"]
//        let Dict56 : NSDictionary = ["time_Slots_id": 14,"days": "Sat","status": "1"]
//        let Dict57 : NSDictionary = ["time_Slots_id": 14,"days": "Sun","status": "1"]
//        let Dict61 : NSDictionary = ["time_Slots_id": 15,"days": "Mon","status": "1"]
//        let Dict62 : NSDictionary = ["time_Slots_id": 15,"days": "Tue","status": "1"]
//        let Dict63 : NSDictionary = ["time_Slots_id": 15,"days": "Wed","status": "1"]
//        let Dict64 : NSDictionary = ["time_Slots_id": 15,"days": "Thu","status": "1"]
//        let Dict65 : NSDictionary = ["time_Slots_id": 15,"days": "Fri","status": "1"]
//        let Dict66 : NSDictionary = ["time_Slots_id": 15,"days": "Sat","status": "1"]
//        let Dict67 : NSDictionary = ["time_Slots_id": 15,"days": "Sun","status": "1"]
//        var schedule = Array<Any>()
//        schedule.append(Dict1)
//        schedule.append(Dict2)
//        schedule.append(Dict3)
//        schedule.append(Dict4)
//        schedule.append(Dict5)
//        schedule.append(Dict6)
//        schedule.append(Dict7)
//        schedule.append(Dict11)
//        schedule.append(Dict12)
//        schedule.append(Dict13)
//        schedule.append(Dict14)
//        schedule.append(Dict15)
//        schedule.append(Dict16)
//        schedule.append(Dict17)
//        schedule.append(Dict21)
//        schedule.append(Dict22)
//        schedule.append(Dict23)
//        schedule.append(Dict24)
//        schedule.append(Dict25)
//        schedule.append(Dict26)
//        schedule.append(Dict27)
//        schedule.append(Dict31)
//        schedule.append(Dict32)
//        schedule.append(Dict33)
//        schedule.append(Dict34)
//        schedule.append(Dict35)
//        schedule.append(Dict36)
//        schedule.append(Dict37)
//        schedule.append(Dict41)
//        schedule.append(Dict42)
//        schedule.append(Dict43)
//        schedule.append(Dict44)
//        schedule.append(Dict45)
//        schedule.append(Dict46)
//        schedule.append(Dict47)
//        schedule.append(Dict51)
//        schedule.append(Dict52)
//        schedule.append(Dict53)
//        schedule.append(Dict54)
//        schedule.append(Dict55)
//        schedule.append(Dict56)
//        schedule.append(Dict57)
//        schedule.append(Dict61)
//        schedule.append(Dict62)
//        schedule.append(Dict63)
//        schedule.append(Dict64)
//        schedule.append(Dict65)
//        schedule.append(Dict66)
//        schedule.append(Dict67)
//        let data = try? JSONSerialization.data(withJSONObject: schedule, options: [])
//        let linkDataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//        print(linkDataString!)
        
        if (firstNameFld.text?.isEmpty)!
        {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Firstname is Empty".localized())
        }
        else if (lastNameFld.text?.isEmpty)!
        {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Lastname is Empty".localized())
        }
        else if (line1.text?.isEmpty)!{
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "AddressLine1 is Empty".localized())
        }
        else if (line2.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "AddressLine2 is Empty".localized())
        }
        else if (cityFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "City is Empty".localized())
        }
        else if (stateFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "state is Empty".localized())
        }
        else if (zipcodeFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Zipcode is Empty".localized())
        }
        else if (aboutYouFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "AboutYou is Empty".localized())
        }
        else if (workExperienceFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "WorkExperience is Empty".localized())
        }
        else if (emailFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Email is Empty".localized())
        }
        else if (passwordFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Password is Empty".localized())
        }
        else if (phoneFld.text?.isEmpty)! {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Phone Number is Empty".localized())
        }
        else if (dobFld.text?.isEmpty)! {
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "DOB is Empty".localized())
        }
        else if (self.categories.count == 0)
        {
            
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Category is Empty".localized())
            
        }
            /*   else if (self.timeSlots.count == 0)
             {
             
             SwiftSpinner.hide()
             
             showAlert(title: "Validation failed", msg: "Time slots is Empty")
             }
             */
        else if (!isImageSelected)
        {
            SwiftSpinner.hide()
            
            showAlert(title: "Validation failed".localized(), msg: "Profile Image is Empty".localized())
        }
        else
        {
            var gen = "Male".localized()
            if SharedObject().hasData(value: genderFld.text){
                gen = genderFld.text!
            }
            var img = ""
            if SharedObject().hasData(value: imageString){
                img = imageString!
            }
        
            
        firstNameFld.text = firstNameFld.text!.trimmingCharacters(in: .whitespaces)
        lastNameFld.text = lastNameFld.text!.trimmingCharacters(in: .whitespaces)
        line1.text = line1.text!.trimmingCharacters(in: .whitespaces)
        line2.text = line2.text!.trimmingCharacters(in: .whitespaces)
        stateFld.text = stateFld.text!.trimmingCharacters(in: .whitespaces)
        aboutYouFld.text = aboutYouFld.text!.trimmingCharacters(in: .whitespaces)
        emailFld.text = emailFld.text!.trimmingCharacters(in: .whitespaces)
        workExperienceFld.text = workExperienceFld.text!.trimmingCharacters(in: .whitespaces)

            
    
        let params: Parameters = [
            "first_name": firstNameFld.text!,
            "last_name": lastNameFld.text!,
            "gender": gen,
            "address1": line1.text!,
            "address2": line2.text!,
            "city": cityFld.text!,
            "state": stateFld.text!,
            "zipcode": zipcodeFld.text!,
            "about": aboutYouFld.text!,
            "workexperience": workExperienceFld.text!,
            "email": emailFld.text!,
            "password": passwordFld.text!,
            "mobile": phoneFld.text!,
            "dob": dobFld.text!,
            "schedules":schedule,
            "category": category,
            "image": img
        ]
        
        print(params)
            SwiftSpinner.show("Almost Done...".localized())
            let url = APIList().getUrlString(url: .SIGNUP)
//            let url = "\(Constants.baseURL)/provider_signup"
            Alamofire.request(url,method: .post,parameters:params).responseJSON { response in
//                print(response)
                if(response.result.isSuccess)
                {
                    SwiftSpinner.hide()
                    if let json = response.result.value {
                        print("SIGNUP JSON: \(json)") // serialized json response
                        let jsonResponse = JSON(json)
                        if(jsonResponse["error"].stringValue == "true")
                        {
                            let errorMessage = jsonResponse["error_message"].stringValue
                            let alertController = UIAlertController(title: "Signup Failed".localized(), message: errorMessage, preferredStyle: .alert)
                            
                            let action1 = UIAlertAction(title: "Ok".localized(), style: .default) { (action:UIAlertAction) in
                                print("You've pressed default");
                                
                                self.clearData()
                                
                            }
                            
                            
                            alertController.addAction(action1)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let alert = UIAlertController(title: "Signup Successful".localized(), message: "Please login".localized(), preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok".localized(), style: UIAlertActionStyle.default, handler: {
                                (alert: UIAlertAction!) in
                                
                                let domain = Bundle.main.bundleIdentifier!
                                UserDefaults.standard.removePersistentDomain(forName: domain)
                                UserDefaults.standard.synchronize()
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SigninViewController") as! SigninViewController
                                self.present(vc, animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
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
    
    @IBAction func getAddress(_ sender: Any)
    {
        
        if LocationCheck.isLocationServiceEnabled() == true
        {
            let stoaryBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let Dvc = stoaryBoard.instantiateViewController(withIdentifier: "AddAddressViewController")as! AddAddressViewController
            Dvc.updatedelegate = self
            present(Dvc, animated: true, completion: nil)     
        }
        else
        {
            self.showAlert(title: "Oops".localized(), msg: "please enable location services in your phone settings to continue".localized())
        }
        
    }
    
    
    func clearData()
    {
        
        for var i in (0..<timeSlots.count)
        {
            let dict : NSDictionary = timeSlots[i].dictionary! as NSDictionary
            
            
            print("dict = ",dict)
            
            
            //             if(timeSlots[i]["status"] == "1"){
            //
            //            let state = dict["status"] as? Int
            
            if (timeSlots[i]["status"].stringValue == "1")
            {
                //                let state: String = dict["days"] as! String
                
                let state =  timeSlots[i]["days"].stringValue
                
                if state == "Mon"
                {
                    self.mondayAddButton.titleLabel?.text = ""
                }
                if state == "Tue"
                {
                    self.tuesdayAddButton.titleLabel?.text = ""
                    
                }
                if state == "Wed"
                {
                    self.wednesdayAddButton.titleLabel?.text = ""
                    
                }
                if state == "Thu"
                {
                    self.thursdayAddButton.titleLabel?.text = ""
                    
                }
                if state == "Fri"
                {
                    self.fridayAddButton.titleLabel?.text = ""
                    
                }
                if state == "Sat"
                {
                    self.saturdayAddButton.titleLabel?.text = ""
                    
                }
                if state == "Sun"
                {
                    self.sundayAddButton.titleLabel?.text = ""
                    
                }
                
            }
        }
        
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
        
        if (!isImageSelected)
        {
            showAlert(title: "Validation failed".localized(), msg: "Profile Image is Empty".localized())
        }
        else
        {
        let url = "\(Constants.baseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
        let img = self.profilePicFld.backgroundImage(for: UIControlState.normal)
        let imagedata = UIImageJPEGRepresentation(img!, 0.8)
        
        
        
        SwiftSpinner.show("Uploading Image".localized())
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers, encodingCompletion: { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    //                    print(jsonResponse)
                   // self.imageName = jsonResponse["image"].stringValue
                    let error = jsonResponse["error"].stringValue
                    if error == "false"
                    {
                        self.imageString = jsonResponse["image"].stringValue
                        print("Succesfully uploaded")
                        self.signUp()
                    }
                    else {
                        self.showAlert(title: "Oops".localized(), msg: "Please Select an Image".localized())
                    }
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
    
    
   /* func uploadImage(){
        
        let url = "\(Constants.adminBaseURL)/imageupload"
        _ = try! URLRequest(url: url, method: .post)
        let img = self.profilePicFld.backgroundImage(for: UIControlState.normal)
        let imagedata = UIImageJPEGRepresentation(img!, 1.0)
        print(imagedata)
        
        
        SwiftSpinner.show("Registering")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imagedata{
                multipartFormData.append(data, withName: "file", fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: nil, encodingCompletion: { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    let jsonResponse = JSON(response.result.value)
                    print(jsonResponse)
                    self.imageString = jsonResponse["image"].stringValue
                    print(self.imageString)
                    print("Succesfully uploaded")
                    if let err = response.error
                    {
                        
                        SwiftSpinner.hide()
                        
                        print(err)
                        self.showAlert(title: "Oops".localized(), msg: err.localizedDescription)
                        return
                    }
                    else
                    {
                        self.signUp()
                    }
                }
            case .failure(let error):
                
                SwiftSpinner.hide()

                print("Error in upload: \(error.localizedDescription)")
            }
        })

    }*/
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == firstNameFld || textField == lastNameFld )
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
        else if (textField == line2 || textField == line1 || textField == cityFld || textField == stateFld || textField == aboutYouFld || textField == aboutYouFld)
        {
            if Int(range.location) == 0 && (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
        }
        else if (textField == emailFld)
        {
            if  (string == " ")
            {
                return false
            }
            else
            {
                return true
            }
        }
        else if (textField == phoneFld) {
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if ((string == filtered))
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
     /*   else if (textField == workExperienceFld)
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS2).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if ((string == filtered))
            {
                let maxLength = 30
                let currentString: NSString = textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                return newString.length <= maxLength
            }
            else {
                return false
            }
//            else if Int(range.location) == 0 && (string == " ")
//            {
//                 return false
//            }
            
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


