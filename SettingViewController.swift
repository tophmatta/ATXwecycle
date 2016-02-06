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
    

    @IBOutlet weak var schedulePicker: UIPickerView!
    
    @IBOutlet weak var pickerQuestionView: UIView!
    
    @IBOutlet weak var welcomeLabelView: UIView!
    
    @IBOutlet weak var nextButtonView: UIView!
    
    @IBOutlet weak var notSureView: UIView!
    
    
    var schedulePickerData = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Format container views
        welcomeLabelView.backgroundColor = UIColor(red: 46/255, green: 215/255, blue: 113/255, alpha: 1.0)
        
        pickerQuestionView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
        
        nextButtonView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
        
        notSureView.backgroundColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    
        //rgba(52, 152, 219,1.0)
                
        // Format background image
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
        
        // Format picker options
        schedulePickerData = ["Week A", "Week B"]
        
        // Define picker delegate/datasource
        self.schedulePicker.delegate = self
        self.schedulePicker.dataSource = self
        
        self.defineManualEdgeConstraints()
        
        
    }
    
    func defineManualEdgeConstraints(){
        
        nextButtonView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        let nextButtonViewWidthRatio: CGFloat = self.view.frame.width * 1/3
        let welcomeLabelViewHeightRatio: CGFloat = self.view.frame.height * (1/3 + 1/10) // 43% of screen ht.
        let pickerQuestionViewHeightRatio: CGFloat = self.view.frame.height * (2/3 + 1/5) // 87% of screen ht.
        
        self.view.addSubview(nextButtonView)
        self.view.addSubview(welcomeLabelView)
        self.view.addSubview(pickerQuestionView)
        
        // Set next button view left edge constraint
        let leftConstraintNextButtonView = NSLayoutConstraint(item: nextButtonView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left , multiplier: 1, constant: nextButtonViewWidthRatio)
        
        // Set welcome label view bottom edge constraint
        let bottomConstraintWelcomeLabelView = NSLayoutConstraint(item: welcomeLabelView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: welcomeLabelViewHeightRatio)
        
        // Set picker question view bottom edge constraint
        let bottomConstraintPickerQuestionView = NSLayoutConstraint(item: pickerQuestionView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: pickerQuestionViewHeightRatio )
        
        // Add constraints
        self.view.addConstraints([leftConstraintNextButtonView, bottomConstraintWelcomeLabelView, bottomConstraintPickerQuestionView])
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
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
    
    

    
    //TODO: Refactor autolayout to have same height ratios of views in all screen sizes, Link to calendar for people to figure out which week they are (cocoapod)

}
