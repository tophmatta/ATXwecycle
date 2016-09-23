//
//  DateModel.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/10/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class DateModel: NSObject {
    
    let calendar = Calendar.current
    
    var todaysDate = Date()
    
    // MARK: Generating recycle dates to be checked
    
    var recycleDatesArr = [Date]()
    
    var recycleWeekStartDate: Date?
    
    // Generates recycling date schedule and appends to array
    func setUpRecycleDatesArray(){
                
        if residencePickerChoice == "Yes" || residencePickerChoice == "Week A" {
            
            // Initialize start of very first recycle week if Week A
            recycleWeekStartDate = convertStringToNSDate("01-10-2016")
            
        } else {
            
            // Initialize start of very first recycle week if Week B(used to generate array of recycle dates)
            recycleWeekStartDate = convertStringToNSDate("01-03-2016")
            
        }
        
        // Specify day in seconds to use for date counter
        let day: Double = 60*60*24
        
        // Create bi-weekly date intervals for recycling every other week
        for _ in 1...26 {
            
            // Add initial recycle week start date plus 5 days after to recycle dates array to mimic a Sun-Fri interval
            for i in 0...5 {
                
                if let futureDate = recycleWeekStartDate?.addingTimeInterval(day * Double(i)) {
                    
                    recycleDatesArr.append(futureDate)
                    
                }
            }
                
            // Adds 2 weeks onto date counter
            recycleWeekStartDate = recycleWeekStartDate?.addingTimeInterval(day * 14)
                
        }
        
    }
    
    // MARK: Converting NSDate <-> String & date checking methods
    fileprivate static var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter
        
    }()
    
    // Takes a date in String form and spits out an NSDate in format specified in 'dateFormatter' lazy var
    func convertStringToNSDate(_ dateString: String) -> Date {
        
        return DateModel.dateFormatter.date(from: dateString)!
        
    }
    
    
    // Takes an NSDate and spits out the string version of it
    func convertNSDateToString(_ date: Date) -> String {
        
        return DateModel.dateFormatter.string(from: date)
        
    }
    
    // Loops through generated recycle dates array and compares to todays date
    func checkTodaysDateToRecycleDatesArray() -> Bool {
        
        var datesMatch = false
        
        for recycleDate in recycleDatesArr {
            
            // Store recycleDate as a string
            let stringRecycleDateFromNSDate = convertNSDateToString(recycleDate)
            
            // Store Todays date as a string
            let stringTodaysDateFromNSDate = convertNSDateToString(todaysDate)
            
            // Dates match, change bool to true
            if stringTodaysDateFromNSDate == stringRecycleDateFromNSDate {
                
                datesMatch = true
                
                return datesMatch
                
            }
        }
        return datesMatch
    }
    
}
