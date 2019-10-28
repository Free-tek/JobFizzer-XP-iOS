//
//  AppDelegate.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 23/10/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import Alamofire
import SocketIO
import SwiftyJSON
import AWSS3
import AWSCore
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager : CLLocationManager!
    var manager : SocketManager!
    var socket : SocketIOClient!
    var manager1 : SocketManager!
    var socket1 : SocketIOClient!
    
    var chatData = NSDictionary()
    var chatReceiveID = ""

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])

        
        GMSServices.provideAPIKey(Constants.mapsKey)
        GMSPlacesClient.provideAPIKey(Constants.placesKey)
        IQKeyboardManager.sharedManager().enable = true
        
        
        Messaging.messaging().delegate = self
        
        FirebaseApp.configure()
        Messaging.messaging().shouldEstablishDirectChannel = true
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APSouth1,
                                                                identityPoolId:Constants.AWS_S3_POOL_ID)
        
        let configuration = AWSServiceConfiguration(region:.APSouth1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
        
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let sender_id = dct.object(forKey: "reciever_id") as! String
                let receiver_id = dct.object(forKey: "sender_id") as! String
                
                let msgData:NSDictionary = ["sender_id": sender_id,"reciever_id":receiver_id]
                
                print("Chat Data = ",msgData)
                
                
                chatData = msgData
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatData"), object: self)//, userInfo: msgData)
                
                
                //                NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil, userInfo: imageDataDict)
                
            }
            else
            {
                MainViewController.reloadPage = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
            }
        }
        else
        {
            MainViewController.reloadPage = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
        }
        
        
        
       
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
            
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let sender_id = dct.object(forKey: "reciever_id") as! String
                let receiver_id = dct.object(forKey: "sender_id") as! String

//                let msgData:[String: String] = ["sender_id": sender_id,"reciever_id":receiver_id]

                
                let msgData:NSDictionary = ["sender_id": sender_id,"reciever_id":receiver_id]

                
                chatData = msgData
                
                print("Chat Data = ",msgData)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatData"), object: self)//, userInfo: msgData)

                
//                NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil, userInfo: imageDataDict)

            }
            else
            {
                MainViewController.reloadPage = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
            }
        }
        else
        {
            MainViewController.reloadPage = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
        }
        
        print("Notification Dictionary = ",dct)

        
        // Print full message.
//        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if socket1 != nil {
            socket1.disconnect()
        }
        if(socket != nil){
            socket.disconnect()
        }
        if(locationManager != nil)
        {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        
        if(isLoggedIn)
        {
        
        
            manager = SocketManager(socketURL: URL(string: Constants.SocketMsg)!, config: [.log(false), .compress, .forcePolling(true)])
            socket = manager.defaultSocket
            
            manager1 = SocketManager(socketURL: URL(string: Constants.SocketUrl)!, config: [.log(false), .compress, .forcePolling(true)])
            socket1 = manager1.defaultSocket
            
            if socket1 != nil
            {
                socket1.connect()
                print("Socket Connected 1")
            }
            
            if(socket != nil)
            {
               
                var uid = ""
                
                if (UserDefaults.standard.object(forKey: "provider_id") != nil)
                {
                    uid = UserDefaults.standard.object(forKey: "provider_id") as! String
                }
                
                socket.on(clientEvent: .connect)
                {
                    data, ack in
                    print("socket connected = ",data)
                    //                    let senderId = UserDefaults.standard.string(forKey: "userId")!
                    self.socket.emit("get_provider_online", ["providerid":uid])
                    self.socket.emit("providerisOnline", ["providerid":uid])
                    
                }
                
                socket.on("recievemessage") {data, ack in
                    let response = JSON(data)
                    print("Recieve Message = ",response)
                    let dataDict:[String: Any] = ["data": data]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MessageReceived"), object: self, userInfo: dataDict)
                    
                }
                
                
            }
            socket.connect()

            
        }
        if(isLoggedIn)
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
           
        }

    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        
        
        if(isLoggedIn)
        {
            
            var uid : String = ""
            
            
            if (UserDefaults.standard.object(forKey: "provider_id") != nil)
            {
                uid = UserDefaults.standard.object(forKey: "provider_id") as! String
                
                socket.emit("providerisOffline", ["providerid":uid])
                
            }
            
            
            
            //            let uid = UserDefaults.standard.string(forKey: "userId")
            //            socket.emit("isOffline", ["userid":uid])
        }
        
    }
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        let currentLatitude = String(coord.latitude)
        let currentLongitude = String(coord.longitude)
        let bearing = String(locationObj.course)
        
        let oldLatitude = UserDefaults.standard.double(forKey: "lastKnownLatitude")
        let oldLongitude = UserDefaults.standard.double(forKey: "lastKnownLongitude")
        
        let provider_id = UserDefaults.standard.string(forKey: "provider_id")
        
        let oldLocation : CLLocation = CLLocation.init(latitude: oldLatitude, longitude: oldLongitude)
        
        let meters: CLLocationDistance = locationObj.distance(from: oldLocation)
        print(meters)
//        if(meters > 10){
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if(isLoggedIn)
            {
                socket1.emit("UpdateLocation", ["latitude": currentLatitude,"longitude":currentLongitude,"provider_id":provider_id,"bearing":bearing])
//            self.updateLocation(latitude: currentLatitude,longitude: currentLongitude, bearing: bearing)
            }
            else{
                
            }
            UserDefaults.standard.set(currentLatitude, forKey: "lastKnownLatitude")
            UserDefaults.standard.set(currentLongitude, forKey: "lastKnownLongitude")

//        }
    }
    
    func updateLocation(latitude:String,longitude:String,bearing:String)
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
        print(latitude)
        print(longitude)
        let params: Parameters = [
            "latitude":latitude,
            "longitude": longitude,
            "bearing" : bearing
        ]
        
//        let url = APIList().getUrlString(url: .)
        let url = "\(Constants.baseURL)/update_location"
        Alamofire.request(url,method: .post, parameters:params, headers:headers).responseJSON { response in
            
           print(response)
        }

    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
        if (error != nil)
        {
            print(error)
        }
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    
    {
        
        
        
        let userInfo = notification.request.content.userInfo
        
        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
        
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let receiver_id = dct.object(forKey: "sender_id") as! String
                
                if chatReceiveID == ""
                {
                    completionHandler([])
                }
                else
                {
                    
                }
                
            }
            else
            {
                Messaging.messaging().appDidReceiveMessage(userInfo)
                
                // Print message ID.
                if let messageID = userInfo[gcmMessageIDKey] {
                    print("Message ID: \(messageID)")
                }
                
                MainViewController.reloadPage = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
                // Print full message.
                print(userInfo)
                
                // Change this to your preferred presentation option
                completionHandler([])
            }
        }
        else
        {
            
            Messaging.messaging().appDidReceiveMessage(userInfo)
            
            // Print message ID.
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            
            MainViewController.reloadPage = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
            // Print full message.
            print(userInfo)
            
            // Change this to your preferred presentation option
            completionHandler([])
            
            
        }
        
        
        
        
      
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void)
    
    {
        

        let userInfo = response.notification.request.content.userInfo

        
        let dct : NSDictionary = userInfo as NSDictionary
        
        
        
        if (dct.object(forKey: "notification_type") != nil)
        {
            let type = dct.object(forKey: "notification_type") as! String
            
            if type == "chat"
            {
                
                let sender_id = dct.object(forKey: "reciever_id") as! String
                let receiver_id = dct.object(forKey: "sender_id") as! String
                
                let msgData:NSDictionary = ["sender_id": sender_id,"reciever_id":receiver_id]
                
                print("Chat Data = ",msgData)
                
                
                chatData = msgData
                
                
                MainViewController.startChat = true

                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChatData"), object: self)//, userInfo: msgData)
                
                
                //                NSNotificationCenter.defaultCenter().postNotificationName(notificationName, object: nil, userInfo: imageDataDict)
                
            }
            else
            {
                MainViewController.reloadPage = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
            }
        }
        else
        {
            MainViewController.reloadPage = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
        }
        
        
    }
    
    
    
    
    /*{
        
        
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        MainViewController.reloadPage = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Refresh"), object: self)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }*/
    
}

