//
//  CommonClass.swift
//  UberdooXP
//
//  Created by Pyramidions on 15/09/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner
import UIKit
import CoreLocation


class Connection
{
    
    
    var bookingID: String = ""
    
    
    func postConnection(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void)
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
        
        
        let url = "\(Constants.baseURL)/" + strURL

        
        let params: Parameters = [
            "booking_id": bookingID
        ]
        
        Alamofire.request(url,method: .post,parameters:params).responseJSON
            {
                response in
                
                if(response.result.isSuccess)
                {
                    let resJson = JSON(response.result.value!)
                    success(resJson)
                }
                else
                {
                    let error : Error = response.result.error!
                    failure(error)
                }
                
        }
    }
    
    
    
}


open class LocationCheck
{
    class func isLocationServiceEnabled() -> Bool
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
                case .notDetermined, .restricted, .denied:
                    return false
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                default:
                    print("Something wrong with Location services")
                return false
            }
        }
        else
        {
            print("Location services are not enabled")
            return false
        }
    }
}

