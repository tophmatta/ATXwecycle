//
//  SettingModalViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 11/29/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//


// TODO: config time picker to move to selected time, get notification to repeat every other week durh!, figure out why notification request in this vc is just the very last one and the requests in the model are all of them - why diff?
import UIKit
import UserNotifications

@available(iOS 10.0, *)
class SettingModalViewController: UIViewController {

    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    let calendar = Calendar.current
    
    let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTimePicker()
        
        // Handles if user decides to turn on notifications while using the app
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        
    }
    
    func applicationDidBecomeActive(){
        
        configureTimePicker()
        
        // Generate and analyze date model
        DateModel.sharedInstance.setUpRecycleDatesArray()
        
    }
    
    func configureTimePicker(){
        
        // Font color
        timePicker.setValue(UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0), forKey: "textColor")
        
        // Forcing to show default time or user chosen time when meny displayed
        var c = DateComponents()
        
        c.hour = notificationHour
        c.minute = notificationMinute
        
        timePicker.date = calendar.date(from: c)!
        
        
        // Get notification settings and determine whether picker should allow interaction
        center.getNotificationSettings(completionHandler: { (settings) in
            
            if settings.authorizationStatus == .authorized {
                
                self.timePicker.isEnabled = true
                
            } else {
                
                self.timePicker.isEnabled = false
                
            }
            
        })
        
    }
    
    
    
    
    @IBAction func datePickerAction(_ sender: Any) {

        let dateComponents = self.calendar.dateComponents([.hour, .minute], from: self.timePicker.date)
        
        notificationHour = dateComponents.hour
        notificationMinute = dateComponents.minute
        
        // Save notification time to be used in DateModel .scheduleLocalNotification via setUpRecycleDatesArray
        userDefaults.set(notificationHour!, forKey: "notificationHour")
        userDefaults.set(notificationMinute!, forKey: "notificationMinute")
        userDefaults.synchronize()
        
        center.removeAllPendingNotificationRequests()
        
        // Schedule notifications to user specified time
        DateModel.sharedInstance.setUpRecycleDatesArray()
        
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changeNotificationSettingPressed(_ sender: Any) {
        
        // Alert msg w/ 'open settings'
        let alert = UIAlertController.init(title: "Toggle Push Notifications", message: "Select 'Open Settings' to continue.", preferredStyle: .alert)
        
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
