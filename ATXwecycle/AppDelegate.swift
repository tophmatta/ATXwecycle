//
//  AppDelegate.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        if (residencePickerChoice != nil) {
//            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let initViewController: UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainview") as! ViewController
//            self.window!.rootViewController? = initViewController
//            
//        }
//        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        userDefaults.set(residencePickerChoice, forKey: "recyclingPref")

    }


}

