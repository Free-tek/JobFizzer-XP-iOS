//
//  Constants.swift
//  UberdooX
//
//  Created by Karthik Sakthivel on 21/10/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Constants {
    //App Constants
    //static var baseURL = "http://104.131.74.144/uber_test/public/provider"
    //static var adminBaseURL = "http://104.131.74.144/uber_test/public/admin"
    static var baseURL = "http://18.223.84.90/uberdoo/public/provider"
    static var adminBaseURL = "http://18.223.84.90/uberdoo/public/admin"
    static var mapsKey = "AIzaSyB83htiPgqjq6JEmaPBVmIj4qO5pHEFtig"
    static var placesKey = "AIzaSyB83htiPgqjq6JEmaPBVmIj4qO5pHEFtig"
    static var locations : [JSON] = []
    static var timeSlots : [JSON] = []
    //139.59.6.161:3000
    static var SocketUrl = "http://18.223.84.90:3000/"
    static var SocketMessage = "http://18.223.84.90:3000"
    static var SocketMsg = "http://18.223.84.90:3000/"
    static var FetchLocation = ""
    //static var  PLACE_HOLDER_IMAGE_URL = "http://139.59.6.161/uberdoo/public/images/uberdoo_placeholder.png"
    
    static let AWS_S3_POOL_ID = "ap-south-1:e292c1db-8a70-439e-a1e8-77196d5dc6dc"
    static let BUCKET_NAME = "zoechatstore"
    
    static let IMAGES_BUCKET = "https://s3.ap-south-1.amazonaws.com/zoechatstore/"
    
}
func validateEmail(enteredEmail:String) -> Bool {
    
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
    
}

func changeTintColor(_ img: UIImageView?, arg color: UIColor?)
{
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


extension UILabel {
    public var substituteFontName : String {
        get {
            print("Font Name = ",self.font.fontName)
            return self.font.fontName;
        }
        set {
            
            
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            
            print("Set Font Name = ",fontName)
            
            
            
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            

            
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}


extension UIButton {
    public var substituteFontName : String {
        get {
            
            print("UIButton Font Name = ",self.titleLabel!.font.fontName)

            return self.titleLabel!.font.fontName;
            
            //            return self.font.fontName ?? "";
        }
        set {
            let fontNameToTest = self.titleLabel?.font.fontName.lowercased() ?? "";
            var fontName = newValue;
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold";
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium";
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light";
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight";
            }
            
//            print("UIButton Font Name = ",self.titleLabel!.font.fontName)

            self.titleLabel?.font = UIFont(name: fontName, size: self.titleLabel?.font.pointSize ?? 17)!
        }
    }
}



func changeFont()
{
    UILabel.appearance().substituteFontName = "Arial";
    UITextView.appearance().substituteFontName = "Arial";
    UIButton.appearance().substituteFontName = "Arial";
    UITextField.appearance().substituteFontName = "Arial";
}
