//
//  SettingModalViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 11/29/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//


// TODO: config time picker to move to selected time
import UIKit
import UserNotifications

class SettingModalViewController: UIViewController {

    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTimePicker()
        
        
    }
    
    func configureTimePicker(){
        
        timePicker.setValue(UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0), forKey: "textColor")        
        
    }
    
    
    @IBAction func datePickerAction(_ sender: Any) {
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        
        print(dateComponents)
        
        notificationHour = dateComponents.hour
        notificationMinute = dateComponents.minute
        
        userDefaults.set(notificationHour!, forKey: "notificationHour")
        userDefaults.set(notificationMinute!, forKey: "notificationMinute")
        userDefaults.synchronize()
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            // Schedule notifications to user specified time
            dateModel.scheduleLocalNotificationForDay()
            
            center.getPendingNotificationRequests(completionHandler: { (request) in
                
                
                print(request)
                
            })
            
        }
        
        
        
        
        
        
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeNotificationSettingPressed(_ sender: Any) {
        
        // Alert msg w/ 'open settings'
        let alert = UIAlertController.init(title: "Toggle Push Notification Service", message: "Select 'Open Settings' to continue.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url as URL)
                
            }
        })
        
        alert.addAction(openAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

}
