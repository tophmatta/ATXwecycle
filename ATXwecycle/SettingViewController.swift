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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Format container views
        welcomeLabelView.backgroundColor = UIColor(red: 46/255, green: 215/255, blue: 113/255, alpha: 1.0)
        pickerQuestionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.35)
        nextButtonView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        notSureView.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        
        // Format background image
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
        
        // Format picker options
        schedulePickerData = ["Week A", "Week B"]
        
        // Define picker delegate/datasource
        self.schedulePicker.delegate = self
        self.schedulePicker.dataSource = self
        
        // Call method to define the open ended constraints not defined via auto-layout
        self.defineManualEdgeConstraints()
        
        
        // Set default picker choice in case there is no event
        self.setDefaultPickerChoice()
        
    }
    
    // This method defines the open ended layout constraints (next button width, height ratios of all views)
    func defineManualEdgeConstraints(){
        
        // Determining height/width ratios to pass to NSLayoutConstraints
        let nextButtonViewWidthRatio: CGFloat = self.view.frame.width * 1/3
        let welcomeLabelViewHeightRatio: CGFloat = self.view.frame.height * (1/3 + 1/10) // 43% of screen ht.
        let pickerQuestionViewHeightRatio: CGFloat = self.view.frame.height * (2/3 + 1/5) // 87% of screen ht.
        
        let views = [nextButtonView, welcomeLabelView, pickerQuestionView, notSureView]
        
        // Loop through to add subviews and disable autoresizing
        for view in views {
            
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        
        // Set next button view width = 2/3 of super view width
        let leftConstraintNextButtonView = NSLayoutConstraint(item: nextButtonView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left , multiplier: 1, constant: nextButtonViewWidthRatio)
        
        // Set welcome label view bottom edge constraint = 43% of super view ht.
        let bottomConstraintWelcomeLabelView = NSLayoutConstraint(item: welcomeLabelView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: welcomeLabelViewHeightRatio)
        
        // Set picker question view bottom edge constraint = 87% of super view ht.
        let bottomConstraintPickerQuestionView = NSLayoutConstraint(item: pickerQuestionView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: pickerQuestionViewHeightRatio )
        
        // Add constraints
        self.view.addConstraints([leftConstraintNextButtonView, bottomConstraintWelcomeLabelView, bottomConstraintPickerQuestionView])
        
    }
    
    // Manually select picker choice (needed for a UIPicker if no event received by UIPickerViewDelegate)
    func setDefaultPickerChoice(){
        
        // Manually set default picker value
        self.schedulePicker.selectRow(0, inComponent: 0, animated: false)
        
        let row = self.schedulePicker.selectedRowInComponent(0)
        
        // Set variable to be saved into user defaults
        residencePickerChoice = schedulePickerData[row]
        
    }
    
    // MARK: -
    // MARK: Delegate Methods
    
    // The # of col. of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    // # of rows in picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return schedulePickerData.count
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return schedulePickerData[row]
        
    }
    
    // Change picker text color attribute
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let options = schedulePickerData[row]
        
        return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)])
        
    }
    
    // Picker selection made (Note: Called only when picker is moved. See default picker func for when no interaction is made)
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        residencePickerChoice = schedulePickerData[row]
        
    }
    
    // MARK: -
    // MARK: IBActions
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        
        userDefaults.setObject(residencePickerChoice!, forKey: "recyclingPref")
        userDefaults.synchronize()
        
    }
    
    @IBAction func noIdeaButtonPressed(sender: AnyObject) {
        
        let webVC: UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("webview")
        
        self.presentViewController(webVC, animated: true, completion: nil)
        
    }
    
    // 'Placeholder' IBAction to signal storyboard which view to 'exit' to
    @IBAction func unwindToSettingVC(sender: UIStoryboardSegue) {
        
        
    }
    
}
