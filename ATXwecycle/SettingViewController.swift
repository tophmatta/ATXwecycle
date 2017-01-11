//
//  SettingViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 2/3/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let globalFuncs = Main()
    
    let center = UNUserNotificationCenter.current()
    
    var pickerData = [[String]]()
    var recyclingDayData = [String]()
    
    @IBOutlet weak var schedulePicker: UIPickerView!
    @IBOutlet weak var pickerQuestionView: UIView!
    @IBOutlet weak var welcomeLabelView: UIView!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var notSureView: UIView!
    
    // MARK: - VC LIFECYCLE METHODS
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format container view's background color
        self.setupSubviewBackgroundColors()
        
        // Format background image
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
        
        // Format picker options
        pickerData = [
            ["Week A", "Week B"],
            ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        ]
        // Define picker delegate/datasource
        self.schedulePicker.delegate = self
        self.schedulePicker.dataSource = self
        
        // Set default picker choice in case there is no event
        self.setDefaultPickerChoice()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    // MARK: - FORMAT UI ELEMENTS
    // Manually select picker choice (needed for a UIPicker if no event received by UIPickerViewDelegate)
    func setDefaultPickerChoice(){
        
        if residencePickerChoice == nil {
            
            // Manually set default picker value
            self.schedulePicker.selectRow(0, inComponent: 0, animated: false)
            
            let row = self.schedulePicker.selectedRow(inComponent: 0)
            
            // Set variable to be saved into user defaults
            residencePickerChoice = pickerData[0][row]
            
        }
        
        if recyclingDay == nil {
            
            // Manually set default picker value
            self.schedulePicker.selectRow(0, inComponent: 1, animated: false)
            
            let row = self.schedulePicker.selectedRow(inComponent: 1)
            
            // Set variable to be saved into user defaults
            recyclingDay = pickerData[1][row]
            
        }
        
        
        
        func setRowForSched(i:Int){
            
            // Manually set default picker value
            self.schedulePicker.selectRow(i, inComponent: 0, animated: false)
                                    
        }
        
        if let resPC = residencePickerChoice {
            
            switch resPC {
                
            case "Week A", "A":
                setRowForSched(i: 0)
                
            case "Week B", "B":
                setRowForSched(i: 1)
                
            default:
                setRowForSched(i: 0)
                
            }
        }
        
        func setRowForDay(i:Int){
            
            self.schedulePicker.selectRow(i, inComponent: 1, animated: false)
            
        }
        
        
        if let rd = recyclingDay {
            
            switch rd {
            case "MONDAY","Monday":
                setRowForDay(i: 0)
            case "TUESDAY", "Tuesday":
                setRowForDay(i: 1)
            case "WEDNESDAY", "Wednesday":
                setRowForDay(i: 2)
            case "THURSDAY", "Thursday":
                setRowForDay(i: 3)
            case "FRIDAY", "Friday":
                setRowForDay(i: 4)
            default:
                setRowForDay(i: 0)
            }
            
            
        }
    }
    
    func setupSubviewBackgroundColors(){
        
        pickerQuestionView.backgroundColor = UIColor.black.withAlphaComponent(0.35)

        welcomeLabelView.backgroundColor = UIColor(red: 46/255,
                                                   green: 215/255,
                                                   blue: 113/255,
                                                   alpha: 1.0)
        
        nextButtonView.backgroundColor = UIColor(red: 189/255,
                                                 green: 195/255,
                                                 blue: 199/255,
                                                 alpha: 1.0)
        
        notSureView.backgroundColor = UIColor(red: 52/255,
                                              green: 152/255,
                                              blue: 219/255,
                                              alpha: 1.0)
        
    }
    
    // MARK: - UIPICKER DATASOURCE/DELEGATE MEHTODS
    // The # of col. of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return pickerData.count
        
    }
    
    // # of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerData[component].count
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[component][row]
        
    }
    
    // Change picker text color attribute
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let options = pickerData[component][row]
        
        if component == 0 {
            
            return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)])
            
        } else {
            
            return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0)])
            
        }
        
        
    }
    
    // Picker selection made (Note: Called only when picker is moved. See default picker func for when no interaction is made)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            residencePickerChoice = pickerData[component][row]
            
        } else {
            
            recyclingDay = pickerData[component][row]
            
        }
        
    }
    
    // MARK: - IBACTIONS
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        
        userDefaults.set(residencePickerChoice!, forKey: "recyclingPref")
        userDefaults.set(recyclingDay!, forKey: "recyclingDay")
        userDefaults.synchronize()
        
        center.removeAllPendingNotificationRequests()

        
    }
}
