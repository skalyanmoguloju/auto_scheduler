//
//  AppDelegate.swift
//  auto_scheduler
//
//  Created by macbook_user on 10/24/16.
//
//

import UIKit
import GooglePlaces
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //  registerPushNotifications()
        registerForPushNotifications(application)
        /*   UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
         if !accepted {
         print("Notification access denied.")
         }
         }*/
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /*   func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
     if notificationSettings.types != UIUserNotificationType() {
     application.registerForRemoteNotifications()
     }
     }
     
     func registerPushNotifications() {
     
     let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
     UIApplication.registerUserNotificationSettings(settings)
     }
     
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     print("---------FUNCTION CALLED----------")
     
     var token: String = ""
     for i in 0..<deviceToken.count {
     token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
     }
     
     print(token)
     print("Registration succeeded!")
     print("Token: ", token)
     }
     
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("Failed to register:", error)
     } */
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        print(deviceToken)
        DataService.deviceid = token;
        //print("Registration succeeded!")
        //print("Token: ", token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        var aps: NSDictionary = NSDictionary()
        var check1: NSNumber = NSNumber()
        
        var alert: NSString = NSString()
        var message: NSString = NSString()
        var bActionRequired = false;
        for (key, value) in userInfo {
            if(key as! String == "bActionRequired"){
                if(value as! String == "true"){
                    bActionRequired = true;
                }
            }
        }
        
        var sType = "NoAction"
        if(bActionRequired){
            for (key, value) in userInfo {
                if(key as! String == "sType"){
                    sType = value as! String;
                }
            }
        }
        
        switch (sType) {
        case "CheckUserExist":
            print("No action");
            break
        case "NewMeetingReq":
            
            var nMeetingId: Int = Int();
            var dStartDate: Date = Date();
            var dEndDate: Date = Date();
            var dDuration: Double = 0;
            for (key, value) in userInfo {
                print(dEndDate)
                if(key as! String == "meetingId"){
                    nMeetingId  = Int(value as! String)!;
                }
                if(key as! String == "dStartDate"){
                    let dDateFormatter2 = DateFormatter()
                    dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
                    
                    print(value);
                    let dDate2: String = value as! String;
                    print(dDate2);
                    dStartDate = dDateFormatter2.date(from: dDate2)!
                    print(dStartDate)
                }
                if(key as! String == "dEndDate"){
                    let dDateFormatter = DateFormatter()
                    dDateFormatter.dateFormat = "YYYY-MM-dd HH:mm";
                    
                    print("----------InDate------------")
                    print(value);
                    let dDate: String = value as! String;
                    print(dDate);
                    dEndDate = dDateFormatter.date(from: dDate)!
                    print(dEndDate)
                }
                if(key as! String == "dDuration"){
                    dDuration = value as! Double
                }
            }
            MapsViewController.getFreeTime(meetingId: nMeetingId, strtDate: dStartDate, endDate: dEndDate, duration: dDuration);
            print("ACTION HERE");
            break
        case "UpdatedSuggestedTimes":
            //var arrSuggDates:[]
            var nMeetingId: String = String();
            var sArrSug: String = String();
//            for (key, value) in userInfo {
//                
//                if(key as! String == "meetingId"){
//                    nMeetingId  = value as! String;
//                    let defaults = UserDefaults.standard;
//                    defaults.set(nMeetingId, forKey: "suggestedTimes1MeetingId");
//                }
//                if(key as! String == "arrSuggestedTimes"){
//                    var sArrSug = value as! NSString;
//                    print(value)
//                    //print(abc);
//                    let defaults = UserDefaults.standard;
//                    defaults.set(sArrSug, forKey: "suggestedTimes");
//                    
//                }
//            }
            
            break
            
            case "FinalizedSuggestedTimes":
                var nMeetingId: Int = Int();
                var dStartDate: Date = Date();
                var dEndDate: Date = Date();
                print(userInfo);
                print("Here we should add this to calendar");
                for (key, value) in userInfo {
                    if(key as! String == "meetingId"){
                        nMeetingId  = Int(value as! String)!;
                    }
                    if(key as! String == "dStartTime"){
                        var sDate  = value as! String;
                        print("--1-- \(dStartDate)");
                        dStartDate = convertStringToDate(sStringDate: sDate);
                        print("--2- \(dStartDate)");
                    }
                    if(key as! String == "dEndTime"){
                        var sDate  = value as! String;
                        print("--1-- \(dStartDate)");
                        dEndDate = convertStringToDate(sStringDate: sDate);
                        print("--2- \(dEndDate)");
                    }
                }
                HomeScreen_ViewController.AddCallenderEvent(dStartTime: dStartDate, dEndTime: dEndDate)
                break;
            
        default:
            print("Untracked action")
            break
        }
        
    }
    
    func convertStringToDate(sStringDate: String) -> Date {
        let dDateFormatter2 = DateFormatter()
        dDateFormatter2.dateFormat = "YYYY-MM-dd HH:mm";
        var dReturnStartDate: Date = Date();
        print(sStringDate);
        dReturnStartDate = dDateFormatter2.date(from: sStringDate)!
        print(dReturnStartDate)
        return dReturnStartDate;
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}

