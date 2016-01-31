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
    
//MARK: Generating recycle dates to be checked
    
    var recycleDatesArr = [NSDate]()
    
    var recycleWeekStartDate: NSDate?
    
    
    /** Generates recycling dates
     */
    func setUpRecycleDatesArray(){
        
        // Initialize start of very first recycle week (used to generate array of recycle dates)
        recycleWeekStartDate = convertStringToNSDate("01-03-2016")
        
        // Specify day in seconds to use for date counter
        let day: Double = 60*60*24
        
        
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
    
    
    //MARK: Converting NSDate <-> String & date checking methods
    private static var dateFormatter: NSDateFormatter = {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        return dateFormatter
        
    }()
    
    
    /**
     Takes a date in String form and spits out an NSDate in format specified in 'dateFormatter' lazy var
     */
    func convertStringToNSDate(dateString: String) -> NSDate {
        
        return DateModel.dateFormatter.dateFromString(dateString)!
        
    }
    
    /**
     Takes an NSDate and spits out the string version of it
     */
    func convertNSDateToString(date: NSDate) -> String {
        
        return DateModel.dateFormatter.stringFromDate(date)
        
    }
    
    /**
     Loops through generated recycle dates array and compares to todays date
     */
    func checkTodaysDateToRecycleDatesArray() -> Bool{
        
        for recycleDate in recycleDatesArr {
            
            // Store dates to be checked as strings converted from NSDates
            let stringRecycleDateFromNSDate = convertNSDateToString(recycleDate)
            
            let stringTodaysDateFromNSDate = convertNSDateToString(todaysDate)
            
            if stringTodaysDateFromNSDate == stringRecycleDateFromNSDate {
                
                return true
                
            }
        }
        return false
    }
}



// TO DO: program to automatically change with the year (don't forget week 4 leap year case; need to keep it specific for 2016), set up control flow for week A and B scheds, set up array of zip codes to determine week A or B Sched, save user defaulst zip code, app first open -> create field to enter home zip to get correct recycling sched, app icon, UI, in app webview to page showing what can and cant be recycled (if page is responsive)
// Problems: doesn't seem recycle weeks are determined by zip but rather roads

