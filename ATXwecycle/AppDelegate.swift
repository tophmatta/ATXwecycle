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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
        let prefVC: UIViewController = storyBoard.instantiateViewController(withIdentifier: "mainview") as! ViewController

        let navVC = storyBoard.instantiateViewController(withIdentifier: "nav") as! UINavigationController
        
        self.window?.rootViewController = navVC
        
        if (residencePickerChoice != nil) {
            
            navVC.pushViewController(prefVC, animated: false)
            
        }
                
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        userDefaults.set(residencePickerChoice, forKey: "recyclingPref")

    }


}
