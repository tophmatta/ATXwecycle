//
//  AppDelegate.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
        let prefVC: UIViewController = storyBoard.instantiateViewController(withIdentifier: "mainview") as! ViewController

        let navVC = storyBoard.instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
        self.window?.rootViewController = navVC
        
        if (residencePickerChoice != nil) {
            
            navVC.pushViewController(prefVC, animated: false)
            
        }
                
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                
//                if granted {
//                    
//                    print("UN access granted")
//                    
//                } else {
//                    
//                    print("UN access denied")
//                    
//                }
                
            }
        }
        
       /*
        FIRApp.configure()
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        
        let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        */
        
        
                
        return true
    }
    
    /*
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        //print("MessageID: \(userInfo["gcm_message_id"]!)")
        
        //print(userInfo)
        
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert],
            categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        if notificationSettings.types != .none {
            
            application.registerForRemoteNotifications()
            
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        //print(token)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register:", error)
        
    }
    
    */

    func applicationWillTerminate(_ application: UIApplication) {
        
        userDefaults.set(residencePickerChoice, forKey: "recyclingPref")

    }


}
