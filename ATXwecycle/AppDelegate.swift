//
//  AppDelegate.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import Firebase

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
        
        registerForPushNotifications(application: application)
        
        FIRApp.configure()
                
        return true
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
        print(token)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register:", error)
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        userDefaults.set(residencePickerChoice, forKey: "recyclingPref")

    }


}
