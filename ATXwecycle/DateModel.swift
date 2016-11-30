//
//  DateModel.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/10/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import UserNotifications

class DateModel: NSObject {
    
    let calendar = Calendar.current
    
    // Note: adjusted date/time to match CST instead of GMT (UK)
    var todaysDate = Date().addingTimeInterval(-6*60*60)
    
    var recycleDatesArr = [Date]()
    
    var recycleWeekStartDate: Date?
    
    // Generates recycling date schedule and appends to array
    func setUpRecycleDatesArray(){
                
        if residencePickerChoice == "Week A" {
            
            // Initialize start of very first recycle week if Week A
            recycleWeekStartDate = convertStringToDate("01-10-2016")
            
        } else {
            
            // Initialize start of very first recycle week if Week B(used to generate array of recycle dates)
            recycleWeekStartDate = convertStringToDate("01-03-2016")
            
        }
        
        // Specify day in seconds to use for date counter
        let day: Double = 60*60*24
        
        // Create bi-weekly date intervals for recycling every other week
        for _ in 1...26*2 {
            
            // Add initial recycle week start date plus 5 days after to recycle dates array to mimic a Sun-Fri interval
            for i in 0...5 {
                
                if let futureDate = recycleWeekStartDate?.addingTimeInterval(day * Double(i)) {
                    
                    recycleDatesArr.append(futureDate)
                    
                }
            }
                
            // Adds 2 weeks onto date counter
            recycleWeekStartDate = recycleWeekStartDate?.addingTimeInterval(day * 14)
                
        }
        
        // Trigger notification for chosen day and time
        scheduleLocalNotificationForDay()
        
    }
    
    
    // MARK: Date formatting
    
    // Specifying format of date
    fileprivate static var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter
        
    }()
    
    // Takes a date in String form and spits out a Date
    func convertStringToDate(_ dateString: String) -> Date {
        
        // Note: had to minus 6 hrs to due time defaulting to GMT(UK) time
        return DateModel.dateFormatter.date(from: dateString)!.addingTimeInterval(-6*60*60)
        
    }
    
    // Takes a Date and spits out the string
    func convertDateToString(_ date: Date) -> String {
        
        return DateModel.dateFormatter.string(from: date)
        
    }
    
    // Loops through generated recycle dates array and compares to todays date
    func checkTodaysDateToRecycleDatesArray() -> Bool {
        
        var datesMatch = false
        
        for recycleDate in recycleDatesArr {
            
            // Store recycleDate as a string
            let recycleDateString = convertDateToString(recycleDate)
            
            // Store Todays date as a string
            let todaysDateString = convertDateToString(todaysDate)
            
            // Dates match, change bool to true
            if todaysDateString == recycleDateString {
                
                datesMatch = true
                
                return datesMatch
                
            }
        }
        
        return datesMatch
    }
    
    //MARK: Local Notification
    func scheduleLocalNotificationForDay() {
        
        var day = 0
        
        // Pull in saved day and assign weekday date component to be used for repeating notification
        switch recyclingDay ?? "" {
            
        case "Monday":
            day = 2
        case "Tuesday":
            day = 3
        case "Wednesday":
            day = 4
        case "Thursday":
            day = 5
        case "Friday":
            day = 6
        default:
            break
            
        }
        
        // Placeholder for day and time components to be determined below
        var dateComponents = calendar.dateComponents([.weekday], from: todaysDate)

        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Don't forget! ☝️", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Tomorrow is recycling", arguments: nil)
            content.sound = UNNotificationSound.default()
            
            
            if notificationHour == nil {
                
                dateComponents.hour = 20

            } else {
                
                dateComponents.hour = notificationHour
                
            }
            
            if notificationMinute == nil {
                
                dateComponents.minute = 0
                
            } else {
                
                dateComponents.minute = notificationMinute
                
            }
            
            // Notification will fire day prior to recycling
            dateComponents.weekday = day - 1
            
            print("Date components: \(dateComponents)")
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let identifier = "general"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request, withCompletionHandler: { (error) in
                
                if let theError = error {
                    
                    print(theError.localizedDescription)
                    
                }
            })
            
            
//            center.getPendingNotificationRequests(completionHandler: { (notification) in
//                
//                print("pending not.: \(notification)")
//                
//            })
            
        } else {
            // Fallback on earlier versions
        }
    }
}
