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
    
    var todaysDate = Date().addingTimeInterval(-6*60*60)
    
    // MARK: Generating recycle dates to be checked
    
    var recycleDatesArr = [Date]()
    
    var recycleDayArr = [Date]()
    
    var recycleWeekStartDate: Date?
    
    // Generates recycling date schedule and appends to array
    func setUpRecycleDatesArray(){
                
        if residencePickerChoice == "Yes" || residencePickerChoice == "Week A" {
            
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
            
            // Signifies specific recycling day of week
            var j = 0
            
            if let recyclingDay_ = recyclingDay {
                
                switch recyclingDay_ {
                    
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
                    
                default: break
                    
                }
            }
            
            // Add initial recycle week start date plus 5 days after to recycle dates array to mimic a Sun-Fri interval
            for i in 0...5 {
                
                if let futureDate = recycleWeekStartDate?.addingTimeInterval(day * Double(i)) {
                    
                    recycleDatesArr.append(futureDate)
                    
                    if i == j {
                        
                        recycleDayArr.append(futureDate)
                        
                    }
                }
            }
                
            // Adds 2 weeks onto date counter
            recycleWeekStartDate = recycleWeekStartDate?.addingTimeInterval(day * 14)
                
        }
        
        //print(recycleDatesArr)
        //print(recycleDayArr)
        
        scheduleLocalNotificationUsing()
        
//        for date in recycleDayArr {
//            
//            scheduleLocalNotificationUsing(date: date)
//            
//        }
    }
    
    
    
    
    // MARK: Converting Date <-> String & date checking methods
    fileprivate static var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
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
    
    
    func scheduleLocalNotificationUsing() {
        
        var todaysDateComponents = calendar.dateComponents([.day, .month, .year], from: todaysDate)
        
        //var dateComponents = calendar.dateComponents([.day, .month, .year], from: date)

        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "Don't forget! ☝️", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "Today is recycling", arguments: nil)
            content.sound = UNNotificationSound.default()
            
            todaysDateComponents.hour = 7
            todaysDateComponents.minute = 39
            
            print("Date components: \(todaysDateComponents)")
            
            
            //let trigger = UNCalendarNotificationTrigger(dateMatching: todaysDateComponents, repeats: false)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let identifier = "general"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
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
