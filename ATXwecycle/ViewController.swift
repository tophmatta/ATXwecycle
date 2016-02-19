//
//  ViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yesOrNoLabel: UILabel?
    
    @IBOutlet weak var questionLabelView: UIView!
    
    // Fetch date data
    let dateModel = DateModel()
    
    // Fetch global funcs
    let globalFuncs = Main()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate and analyze date model
        self.dateModel.setUpRecycleDatesArray()
        self.dateModel.checkTodaysDateToRecycleDatesArray()
        
        // Format UI elements
        self.formatYesNoLabel()
        questionLabelView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
                
    }

    func formatYesNoLabel(){
        
        if let tempLabel = yesOrNoLabel {
           
            // Define shape
            tempLabel.clipsToBounds = true
            tempLabel.layer.cornerRadius = 30
            
            // Define UIColors
            let labelColorRed = UIColor(red: 240/255, green: 76/255, blue: 60/255, alpha: 1.0)
            let labelColorGreen = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
            
            // Set initial label conditions
            tempLabel.backgroundColor = labelColorRed
            tempLabel.text = "No"
            
            // Pull in data checking whether date matches a recycle date
            let recycleDateCheckBool: Bool = dateModel.checkTodaysDateToRecycleDatesArray()
            
            // Change condition if recycle date is valid
            if recycleDateCheckBool {
                
                tempLabel.backgroundColor = labelColorGreen
                tempLabel.text = "Yes"
                
            }
            
            
        }
        
    }

}

