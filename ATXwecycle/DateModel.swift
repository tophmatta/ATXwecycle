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
    
    static let sharedInstance = DateModel()
    
    private override init() {}
    
    let calendar = Calendar.current
    
    // Note: adjusted date/time to match CST instead of GMT (UK)
    var todaysDate = Date().addingTimeInterval(-6*60*60)
    
    var recycleWeekDatesArr = [Date]()
    
    var recycleDayDatesArr = [Date]()
    
    var recycleWeekStartDate: Date?
    
    var notificationCounter = 0
    
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
        
        recycleWeekDatesArr.removeAll()
        recycleDayDatesArr.removeAll()
        
        // Create bi-weekly date intervals for recycling every other week
        for _ in 1...26*2 {
            
            // Add initial recycle week start date plus 5 days after to recycle dates array to mimic a Sun-Fri interval
            for i in 0...5 {
                
                var j = Int()
                
                switch recyclingDay ?? "" {
                    
                case "Monday":
                    j = 1
                case "Tuesday":
                    j = 2
                case "Wednesday":
                    j = 3
                case "Thursday":
                    j = 4
                case "Friday":
                    j = 5
                    
                default:
                    break
                    
                }
                
                // Creating date with last hour and last second of date (17*60*60 + 59*60 + 59) + 6am default shift from GMT to handle .orderedSame edge case. For instance, if a 0 o clock time was used when the date algorithm ran, ComparisonResult.orderedSame would be passed over. Even though the day date was being compared, somehow this had an effect.
                if let futureDate = recycleWeekStartDate?.addingTimeInterval(day * Double(i)).addingTimeInterval(64799) {
                    
                    // Eliminates past dates from now until initialization date
                    if calendar.compare(todaysDate, to: futureDate, toGranularity: .day) == ComparisonResult.orderedAscending || calendar.compare(todaysDate, to: futureDate, toGranularity: .day) == ComparisonResult.orderedSame {
                        
                        recycleWeekDatesArr.append(futureDate)
                        
                        // Add dates of recycle day to array to lay foundation for push notification date component triggers
                        if i == j {
                            
                            recycleDayDatesArr.append(futureDate)
                            
                            if #available(iOS 10.0, *) {
                                let center = UNUserNotificationCenter.current()
                                
                                center.getNotificationSettings(completionHandler: { (settings) in
                                    
                                    if settings.authorizationStatus == .authorized {
                                        
                                        self.scheduleLocalNotification(futureDate)
                                        
                                        self.notificationCounter += 1
                                        
                                    }
                                })
                                
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
            }
                
            // Adds 2 weeks onto date counter
            recycleWeekStartDate = recycleWeekStartDate?.addingTimeInterval(day * 14)
            
            
        }
                
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                
                if settings.authorizationStatus == .authorized {
                    
                    UNUserNotificationCenter.current().getPendingNotificationRequests { (not) in
                        
                        print(not.first!)
                        
                    }
                    
                }
            })
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    // MARK: Date formatting
    
    // Specifying format of date
    fileprivate static var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        
        return dateFormatter
        
    }()
    
    // Takes a date in String form and spits out a Date
    func convertStringToDate(_ dateString: String) -> Date {
        
        return DateModel.dateFormatter.date(from: dateString)!
        
    }
    
    // Takes a Date and spits out the string
    func convertDateToString(_ date: Date) -> String {
        
        return DateModel.dateFormatter.string(from: date)
        
    }
    
    // Loops through generated recycle dates array and compares to todays date
    func checkTodaysDateToRecycleDatesArray() -> Bool {
        
        var datesMatch = false
        
        for recycleDate in recycleWeekDatesArr {
            
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
    func scheduleLocalNotification(_ date: Date) {
        
        // Subtracting day for notification
        let dateLessOneDay = calendar.date(byAdding: .day, value: -1, to: date)
        
        // Split date arg into components
        var dateComponents = calendar.dateComponents([.month, .day, .year], from: dateLessOneDay!)
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Don't forget! ☝️", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Tomorrow is recycling", arguments: nil)
            content.sound = UNNotificationSound.default()
            
            // Set up default notification time of 8pm day before unless one is chosen in settings
            if notificationHour == nil {
                
                notificationHour = 20
                
                dateComponents.hour = notificationHour

            } else {
                
                dateComponents.hour = notificationHour
                
            }
            
            if notificationMinute == nil {
                
                notificationMinute = 0
                
                dateComponents.minute = notificationMinute
                
            } else {
                
                dateComponents.minute = notificationMinute
                
            }
            
            // Notification will fire day prior to recycling
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let identifier = "general " + String(notificationCounter)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            
            center.add(request, withCompletionHandler: { (error) in
                
                
                if let theError = error {
                    
                    print(theError.localizedDescription)
                    
                }
            })
            
            
        } else {
            // Fallback on earlier versions
        }
    }
}
