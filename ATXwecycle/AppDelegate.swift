//
//  AppDelegate.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
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
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        userDefaults.set(residencePickerChoice, forKey: "recyclingPref")

    }


}
