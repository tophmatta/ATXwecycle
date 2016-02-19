//
//  DateModel.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/10/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class DateModel: NSObject {
    
    let calendar = NSCalendar.currentCalendar()
    
    var todaysDate = NSDate()
    
    // MARK: Generating recycle dates to be checked
    
    var recycleDatesArr = [NSDate]()
    
    var recycleWeekStartDate: NSDate?
    
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
        for week in 1...26 {
            
            // Add initial recycle week start date plus 5 days after to recycle dates array to mimic a Sun-Fri interval
            for var i: Double = 0; i < 6; i++ {
                
                if let futureDate = recycleWeekStartDate?.dateByAddingTimeInterval(day * i) {
                    
                    recycleDatesArr.append(futureDate)
                    
                }
            }
            
            // Pulls year date component from todays date
            let yearFromTodaysDate = calendar.component(.Year, fromDate: todaysDate)
            
            // Biweekly counter of setting recycling week start date
            if week == 4 && yearFromTodaysDate == 2016 {
                
                // Leap year week causes counter to be behind by 1 b/c of extra day ∴ add 1 to counter
                recycleWeekStartDate = recycleWeekStartDate?.dateByAddingTimeInterval(day * 15)
                
            } else {
                
                // Normal counting intveral
                recycleWeekStartDate = recycleWeekStartDate?.dateByAddingTimeInterval(day * 14)
                
            }
        }
    }
    
    // MARK: Converting NSDate <-> String & date checking methods
    private static var dateFormatter: NSDateFormatter = {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter
        
    }()
    
    // Takes a date in String form and spits out an NSDate in format specified in 'dateFormatter' lazy var
    func convertStringToNSDate(dateString: String) -> NSDate {
        
        return DateModel.dateFormatter.dateFromString(dateString)!
        
    }
    
    
    // Takes an NSDate and spits out the string version of it
    func convertNSDateToString(date: NSDate) -> String {
        
        return DateModel.dateFormatter.stringFromDate(date)
        
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

// TO DO: program to automatically change with the year (don't forget week 4 leap year case; need to keep it specific for 2016), add recycling guide