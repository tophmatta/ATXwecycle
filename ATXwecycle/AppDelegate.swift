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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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

    func applicationWillTerminate(application: UIApplication) {
        
        userDefaults.setObject(residencePickerChoice, forKey: "recyclingPref")

    }


}

