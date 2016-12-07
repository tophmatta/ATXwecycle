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

class SettingModalViewController: UIViewController {

    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTimePicker()
        
        
    }
    
    func configureTimePicker(){
        
        // Font color
        timePicker.setValue(UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0), forKey: "textColor")
        
        // Forcing to show default time or user chosen time when meny displayed
        var c = DateComponents()
        
        c.hour = notificationHour
        c.minute = notificationMinute
        
        timePicker.date = calendar.date(from: c)!
        
    }
    
    
    
    
    @IBAction func datePickerAction(_ sender: Any) {
        
        let dateComponents = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        
        notificationHour = dateComponents.hour
        notificationMinute = dateComponents.minute
        
        userDefaults.set(notificationHour!, forKey: "notificationHour")
        userDefaults.set(notificationMinute!, forKey: "notificationMinute")
        userDefaults.synchronize()
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            // Schedule notifications to user specified time
            DateModel.sharedInstance.setUpRecycleDatesArray()
            
            
//            center.getPendingNotificationRequests(completionHandler: { (request) in
//                
//                print(request)
//                
//            })
            
        }
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
