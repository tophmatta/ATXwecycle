//
//  ViewController.swift
//  ATXwecycle
//
//  Created by Toph Matta on 1/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yesOrNoLabel: UILabel!
    
    @IBOutlet weak var isItRecyclingLabel: UILabel!
    
    let dateModel = DateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateModel.setUpRecycleDatesArray()
        
        self.formatLabelCorners()
        
        self.setBlurredBackgroundImage()
        
        self.dateModel.checkTodaysDateToRecycleDatesArray()
        
    }

    func setBlurredBackgroundImage(){
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImage = UIImage(named: "TreeSit.JPG")
        
        let blurRad: CGFloat = 10.0
        
        let backgroundImageWithBlurEffect = UIImageEffects.imageByApplyingBlurToImage(backgroundImage, withRadius: blurRad, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        
        let backgroundImageView = UIImageView(image: backgroundImageWithBlurEffect)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(backgroundImageView)
        
        backgroundImageView.frame.origin = self.view.frame.origin
        
        backgroundImageView.contentMode = .ScaleAspectFit
        
        let backgroundIVTopConstraint: NSLayoutConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([backgroundIVTopConstraint])
        
        self.view.sendSubviewToBack(backgroundImageView)
        
    }
    
    
    //TODO: CREATE METHOD TO CALL WHEN IT IS OR ISN'T RECYCLING.
    func formatLabelCorners(){
        
        yesOrNoLabel.clipsToBounds = true
        yesOrNoLabel.layer.cornerRadius = 30
        
        yesOrNoLabel.backgroundColor = UIColor(red: 240/255, green: 76/255, blue: 60/255, alpha: 1.0)
        
        // rgb(46, 204, 113) for green
        
    }


}

