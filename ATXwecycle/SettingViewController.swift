//
//  SettingViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 2/3/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let globalFuncs = Main()
    
    var schedulePickerData = [String]()
    
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
        schedulePickerData = ["Week A", "Week B"]
        
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
            residencePickerChoice = schedulePickerData[row]
            
        }
        
        func setRow(i:Int){
            
            // Manually set default picker value
            self.schedulePicker.selectRow(i, inComponent: 0, animated: false)
                                    
        }
        
        if let resPC = residencePickerChoice {
            
            switch resPC {
                
            case "Week A", "A":
                setRow(i: 0)
                
            case "Week B", "B":
                setRow(i: 1)
                
            default:
                setRow(i: 0)
                
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
        
        return 1
        
    }
    
    // # of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return schedulePickerData.count
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return schedulePickerData[row]
        
    }
    
    // Change picker text color attribute
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let options = schedulePickerData[row]
        
        return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)])
        
    }
    
    // Picker selection made (Note: Called only when picker is moved. See default picker func for when no interaction is made)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        residencePickerChoice = schedulePickerData[row]
        
    }
    
    // MARK: - IBACTIONS
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        
        userDefaults.set(residencePickerChoice!, forKey: "recyclingPref")
        userDefaults.synchronize()
        
    }
}
