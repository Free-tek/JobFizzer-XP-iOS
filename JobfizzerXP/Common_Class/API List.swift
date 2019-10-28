//
//  API.swift
//  UberdooXP
//
//  Created by admin on 12/4/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import Foundation
import UIKit

struct APIList
{
    //http://139.59.6.161/uberdoo
    let BASE_URL = "http://18.223.84.90/uberdoo/public/provider/"
    //let BASE_URL = "http://104.131.74.144/uber_test/public/provider/"
    func getUrlString(url: urlString) -> String
    {
        return BASE_URL + url.rawValue
    }
}


enum urlString: String
{
    
    case APPSETTINS = "appsettingsprovider"
    case UPDATEDEVICETOKEN = "updatedevicetoken"
    case SIGNIN = "providerlogin"
    case SIGNUP = "provider_signup"
    case HOMEDASHBOARD = "homedashboard"
    case STARTJOB = "startedjob"
    case STARTTOCUSTOMERPLACE = "starttocustomerplace"
    case FINISHJOB = "completedjob"
    case MESSAGELIST = "usermsglist"
    case LOGOUT = "logout"
//    case CHATLIST = "userchatlist"
    case LISTCATEGORY = "listcategory"
    case VIEWPROFILE = "viewprofile"
    case UPDATE_ADDRESS = "update_address"
    case PROVIDER_CALENDER = "providercalender"
    case CALENDER_BOOKING_DETAILS = "calenderbookingdetails"
    case CANCEL_BY_PROVIDER = "cancelbyprovider"
    case CHANGEPASSWORD = "changepassword"
    case EDIT_CATEGORY = "edit_category"
    case DELETE_CATEGORY = "delete_category"
    case FORGETPASSWORD = "forgotpassword"
    case REJECT_BOOKING = "rejectbooking"
    case REJECT_RANDOM_REQUEST = "reject_random_request"
    case ACCEPT_BOOKING = "acceptbooking"
    case ACCEPT_RANDOM_BOOKING = "accept_random_request"
    case OTPCHECK = "otpcheck"
    case PAYMENT_ACCEPT = "paymentaccept"
    case RESETPASSWORD = "resetpassword"
    case USERREVIEWS = "userreviews"
    case VIEW_SHECDULES = "view_schedules"
    case UPDATE_SHEDULES = "updateschedules"
    case VIEW_PROVIDER_CATEGORY = "view_provider_category"
    case ADD_CATEGORY = "add_category"
    case GETPROVIDERLOCATION = "getproviderlocation"
    case UPDATEPROFILE = "updateprofile"
    
    
//    case CHECKMOBILENUMBER = "mobileNumberAvailability"
//    case USERLOGIN = "userLogin"
//
//    case OTPVERIFICATION = "otpVerification"
//    case CHANGEPASSWORD = "changePassword"
//    case USERPROFILE = "userProfile"
//
//    case LISTADDRESS = "listAddress"
//    case UPDATEADDRESS = "updateAddress"
//    case ADDADDRESS = "addAddress"
//    case LISTRESTRAUNT = "listRestaurant"
//    case GETCURRENTADDRESS = "getCurrentAddress"
//    case LISTDISHES = "listDishes"
//    case CARTADD = "cartAdd"
//    case CARTLISTS = "cartLists"
}
