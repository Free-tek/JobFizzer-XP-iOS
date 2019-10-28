//
//  TrackingViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class TrackingViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    var bookingDetails : [String:JSON]!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var jobLocation : CLLocationCoordinate2D!
    var providerLocation : CLLocationCoordinate2D!
    
    var jobMarker : GMSMarker!
    var providerMarker : GMSMarker!
    
    var bounds:GMSCoordinateBounds!
    var currentLatitude : String!
    var currentLongitude : String!
    var foundCurrentLocation = false
    var providerId : String!
    var timer : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        providerName.text = self.bookingDetails["providername"]?.stringValue
        self.providerId = self.bookingDetails["providername"]?.stringValue
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(TrackingViewController.updateLocation), userInfo: nil, repeats: true)
        
        let desLat = self.bookingDetails["boooking_latitude"]!.doubleValue
        let desLon = self.bookingDetails["booking_longitude"]!.doubleValue
        
        jobLocation = CLLocationCoordinate2D.init(latitude: desLat, longitude: desLon)
        jobMarker = GMSMarker.init(position: jobLocation)
        jobMarker.icon = UIImage.init(named: "track_location")
        jobMarker.map = self.mapView
        
        let providerLat = self.bookingDetails["provider_latitude"]!.doubleValue
        let providerLon = self.bookingDetails["provider_longitude"]!.doubleValue
        
        providerLocation = CLLocationCoordinate2D.init(latitude: providerLat, longitude: providerLon)
        providerMarker = GMSMarker.init(position: providerLocation)
        //        providerMarker.rotation =
        providerMarker.map = self.mapView
        
        
        self.bounds = GMSCoordinateBounds.init(coordinate: providerLocation, coordinate: jobLocation)
        
        let cameraUpdate : GMSCameraUpdate = GMSCameraUpdate.fit(self.bounds)
        
        getPolylineRoute(from: providerLocation,to: jobLocation)
        self.mapView.animate(with: cameraUpdate)
        do{
            let filePath: String? = Bundle.main.path(forResource: "map", ofType: "json")
            
            let url = URL.init(fileURLWithPath: filePath!)
            mapView.mapStyle = try GMSMapStyle.init(contentsOfFileURL: url)
            mapView.delegate = self
            
            
        }
        catch{
            print(error)
        }
//        updateLocation()
        
        // Do any additional setup after loading the view.
    }
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor =  UIColor.init(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
        polyline.map = mapView // Your map view
    }
    
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(Constants.mapsKey)")!
        print(url)
        
        Alamofire.request(url,method: .get).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                if let json = response.result.value {
                    let jsonResponse = JSON(json)
                    print(jsonResponse)
                    if let routes = jsonResponse["routes"].array{
                        if(routes.count>0)
                        {
                            if let overview_polyline = routes[0]["overview_polyline"].dictionary
                            {
                                let points = overview_polyline["points"]?.stringValue
                                self.showPath(polyStr: points!)
                            }
                            
                            if let legs = routes[0]["legs"].array{
                                if(legs.count > 0)
                                {
                                    if let distance = legs[0]["distance"].dictionary{
                                        self.distanceLbl.text = distance["text"]?.stringValue
                                    }
                                    if let duration = legs[0]["duration"].dictionary{
                                        self.timeLbl.text = duration["text"]?.stringValue
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        
    }
    @objc func updateLocation()
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
        
        let providerId = self.bookingDetails["provider_id"]?.stringValue
        var provider = ""
        if SharedObject().hasData(value: providerId)
        {
            provider = providerId!
        }
        let params: Parameters = [
            "provider_id":provider
        ]
        //        SwiftSpinner.show("Fetching Location...")
//        let url = "\(Constants.baseURL)/getproviderlocation"
        let url = APIList().getUrlString(url: .GETPROVIDERLOCATION)
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
            if(response.result.isSuccess)
            {
                //                SwiftSpinner.hide()
                if let json = response.result.value {
                    print("PROVIDER LOCATION JSON: \(json)") // serialized json response
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
                        let latitude = jsonResponse["latitude"].doubleValue
                        let longitude = jsonResponse["longitude"].doubleValue
                        
                        
                        self.providerLocation.latitude = latitude
                        self.providerLocation.longitude = longitude
                        
                        
                        self.getPolylineRoute(from: self.providerLocation,to: self.jobLocation)
                        
                        self.bounds = GMSCoordinateBounds.init(coordinate: self.providerLocation, coordinate: self.jobLocation)
                        
                        let cameraUpdate : GMSCameraUpdate = GMSCameraUpdate.fit(self.bounds)
                        self.mapView.animate(with: cameraUpdate)
                        
                        
                    }
                }
            }
            else{
                print(response.error.debugDescription)
                self.showAlert(title: "Oops", msg: response.error!.localizedDescription)
                
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
  /*  func showAlert(title: String,msg : String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    } */
    
    
    @IBAction func updateCamera(_ sender: Any) {
        let cameraUpdate : GMSCameraUpdate = GMSCameraUpdate.fit(self.bounds)
        
        getPolylineRoute(from: providerLocation,to: jobLocation)
        self.mapView.animate(with: cameraUpdate)
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
        
        //        if(!providersLoaded)
        //        {
        //            providersLoaded = true
        //            getProviders(city: "Chennai", latitude: String(coord.latitude), longitude: String(coord.longitude))
        //        }
        //
        
        
        
    }
    
    @IBAction func moveCameraToCurrentLocation(_ sender: Any) {
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(currentLatitude)!, longitude: Double(currentLongitude)!, zoom: 15.0)
        //            print(camera)
        if(mapView != nil)
        {
            mapView.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error != nil)
        {
            print(error)
        }
    }
    
}

