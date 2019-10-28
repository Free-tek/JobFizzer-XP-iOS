//
//  AddAddressViewController.swift
//  Wedoinstall pro
//
//  Created by admin on 8/31/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import SwiftSpinner
import Alamofire

protocol UpdateAddressDelegate
{
    func updateAddress(Address1 : String, Address2 : String , state : String, Zipcode : String , City : String )
}


class AddAddressViewController: UIViewController, UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate
{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleFld: UITextField!
    @IBOutlet weak var crossHair: UIButton!
    @IBOutlet weak var addAddress: UIButton!
    @IBOutlet weak var addressCardView: CardView!
    
    @IBOutlet weak var Done: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var landmarkFld: UITextField!
    @IBOutlet weak var doorNoFld: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    var currentAddress : String!
    var updatedelegate : UpdateAddressDelegate!
    @IBOutlet weak var currentAddressLbl: UILabel!
    var locationManager : CLLocationManager!
    var currentLatitude : String!
    var currentLongitude : String!
    var selectedLatitude = ""
    var selectedLongitude = ""
    var foundCurrentLocation = false
    var isShowing = false
    @IBOutlet weak var locationIndicator: UIImageView!
    var marker:GMSMarker!
    var city = ""
    
    
    
    
    @IBOutlet weak var btnDone: UIButton!
    
    
    var address1 = ""
    var address2 = ""
//    var city = ""
    var zipcode = ""
    var state = ""
    
    var mycolor = UIColor()
    var existingApiCall = false;
    var centerMapCoordinate:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        doorNoFld.delegate = self
//        landmarkFld.delegate = self
        
        titleLbl.text = "Add new address".localized()
        
        btnDone.titleLabel?.font = FontBook.Regular.of(size: 17)
        
        currentAddressLbl.font = FontBook.Regular.of(size: 15)
        titleLbl.font = FontBook.Medium.of(size: 20)
        
        btnDone.layer.cornerRadius = 5.0
        btnDone.clipsToBounds = true
        
        mapView.isMyLocationEnabled = true
        
        
        currentAddressLbl.text = "Fetching...".localized()
        
        
        do{
            
            let filePath: String? = Bundle.main.path(forResource: "map", ofType: "json")
            
//            let url = URL.init(fileURLWithPath: filePath!)
//            mapView.mapStyle = try GMSMapStyle.init(contentsOfFileURL: url)
            mapView.delegate = self
        }
        catch{
            print(error)
        }
        
        //
        //        self.bottomView.frame.origin.y = self.bottomView.frame.origin.y + 270
        //
        //        self.addAddress.frame.origin.y = self.addAddress.frame.origin.y + 270
        //
        locationIndicator.layer.shadowColor = UIColor.gray.cgColor
        locationIndicator.layer.shadowOffset = CGSize(width: 0, height: 1)
        locationIndicator.layer.shadowOpacity = 1
        locationIndicator.layer.shadowRadius = 1.0
        locationIndicator.clipsToBounds = false
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "myColor") != nil
        {
            //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
            let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
            //            var color: UIColor? = nil
            mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
//            addAddress.tintColor = mycolor
            btnDone.backgroundColor = mycolor
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
//        self.view.bringSubview(toFront: self.bottomView)
        self.view.bringSubview(toFront: self.addressCardView)
        
        

        
    }
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if(gesture)
        {
            print("Dragging")
        }
        else{
            print("No Dragging")
        }
    }
    
    //    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    //        if
    //    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if(!existingApiCall)
        {
            existingApiCall = true
            getAddressFor(location: centerMapCoordinate)
        }
        //        self.placeMarkerOnCenter(centerMapCoordinate:centerMapCoordinate)
    }
    
    func getAddressFor(location : CLLocationCoordinate2D){
        GMSGeocoder().reverseGeocodeCoordinate(location) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                self.selectedLatitude = String(location.latitude)
                self.selectedLongitude = String(location.longitude)
                
                self.currentAddress = lines.joined(separator: " ")
                
//                let pm = response! as [CLPlacemark]
//                if pm.count > 0 {
//                    let pm = response![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
//                    var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
//                    if pm.locality != nil {
//                        addressString = addressString + pm.locality! + ", "
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
//
//
//                    print(addressString)
//                }
                self.currentAddressLbl.text = self.currentAddress
                let line = lines.count
                if line > 0 {
                    if address.subLocality != nil {
                         self.city = (address.subLocality)!
                    }
                    if address.postalCode != nil {
                     self.zipcode = address.postalCode!
                    }
                    if address.country != nil {
                       self.state = address.country!
                    }
                    if address.thoroughfare != nil {
                       self.address1 = address.thoroughfare!
                    }
                    if address.locality != nil {
                      self.address2 = address.locality!
                    }
                }
               
                 print("city =",self.city)
                 print("address2 =",self.address2)
                 print("address1 =",self.address1)
                 print("state =",self.state)
                 print("zipcode =", self.zipcode)
               
                
                
//                self.address1 = address.
                print(self.city)
                print(self.currentAddress)
                self.existingApiCall = false
                
            }
        }
    }
    
    @IBAction func DonePressed(_ sender: Any)
    {
        updatedelegate.updateAddress(Address1: address1, Address2: address2, state: state, Zipcode: zipcode, City: city)
        dismiss(animated: true, completion: nil)
    }
    func placeMarkerOnCenter(centerMapCoordinate:CLLocationCoordinate2D) {
        if marker == nil {
            marker = GMSMarker()
        }
        marker.position = centerMapCoordinate
        marker.map = self.mapView
    }
   /* func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }*/
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAddress(_ sender: Any)
    {
        
        let validationFalied = "Validation Failed".localized()
        
        if(titleFld.text == "")
        {
            self.showAlert(title: validationFalied, msg: "Title is required".localized())
        }
        else if(doorNoFld.text == "")
        {
            self.showAlert(title: validationFalied, msg: "Door No. is required".localized())
        }
        else{
            print("Confirm")
//            saveAddress()
        }
    }
 /*
    func saveAddress(){
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
        print(UserDefaults.standard.string(forKey: "access_token") as String!)
        var lmark : String!
        //        let city = "Chennai"
        if let landmark = self.landmarkFld.text
        {
            lmark = landmark
        }
        else{
            lmark = ""
        }
        print(self.currentAddress)
        print(city)
        print(self.doorNoFld.text!)
        print(lmark)
        print(self.titleFld.text!)
        print(currentLatitude)
        print(currentLongitude)
        if(selectedLatitude == "")
        {
            selectedLatitude = currentLatitude
        }
        if(selectedLongitude == "")
        {
            selectedLongitude = currentLongitude
        }
        
        var address = ""
        
        var landmark = ""
        if SharedObject().hasData(value: currentAddress){
            address = currentAddress!
        }
        if SharedObject().hasData(value: lmark){
            landmark = lmark!
        }
        
        let params: Parameters = [
            "address": address,
            "city":city,
            "doorno": self.doorNoFld.text!,
            //            "landmark":landmark,
            "title":self.titleFld.text!,
            "latitude": selectedLatitude,
            "longitude": selectedLongitude
        ]
        SwiftSpinner.show("Saving your address...")
        let url = "\(Constants.baseURL)/api/addaddress"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("ADD ADDRESS JSON: \(json)") // serialized json response
                    let jsonResponse = JSON(json)
                    if(jsonResponse["error"].stringValue == "true" )
                    {
                        self.showAlert(title: "Oops", msg: jsonResponse["error_message"].stringValue)
                    }
                    else if(jsonResponse["error"].stringValue == "Unauthenticated")
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                    else{
                        self.dismiss(animated: true, completion: nil)
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
 */
    @IBAction func showHideBottomView(_ sender: Any) {
        
        if(isShowing)
        {
            isShowing = false
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                
                self.mapView.isUserInteractionEnabled = true
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.crossHair.transform = CGAffineTransform(translationX: 0, y: 0)
                self.locationIndicator.transform = CGAffineTransform(translationX: 0, y: 0)
                self.mapView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.addAddress.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { (Void) in
                
            }
        }
        else{
            isShowing = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.showHideTransitionViews, animations: {
                self.mapView.isUserInteractionEnabled = false
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -270)
                self.crossHair.transform = CGAffineTransform(translationX: 0, y: -270)
                self.locationIndicator.transform = CGAffineTransform(translationX: 0, y: -100)
                self.mapView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.addAddress.transform = CGAffineTransform(translationX: 0, y: -270)
                
            }) { (Void) in
                
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        currentLatitude = String(coord.latitude)
        currentLongitude = String(coord.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coord.latitude, longitude: coord.longitude, zoom: 15.0)
        //            print(camera)
        if(mapView != nil && !foundCurrentLocation)
        {
            foundCurrentLocation = true
            mapView.camera = camera
        }
        
        
        centerMapCoordinate = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)        
        cameraMoveToLocation(toLocation: centerMapCoordinate)
        
        
        locationManager.stopUpdatingLocation()

    }
    
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?)
    {
        if toLocation != nil
        {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
            getAddressFor(location: centerMapCoordinate)
        }
    }
    
    
    @IBAction func moveCameraToCurrentLocation(_ sender: Any) {
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(currentLatitude)!, longitude: Double(currentLongitude)!, zoom: 15.0)
        //            print(camera)
        locationManager.stopUpdatingLocation()
        if(mapView != nil)
        {
            mapView.animate(to: camera)
            getAddressFor(location: centerMapCoordinate)
        }
    }
    @IBAction func searchLocation(_ sender: Any) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
}
