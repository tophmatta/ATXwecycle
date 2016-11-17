//
//  global.swift
//  ATXwecycle
//
//  Created by Toph Matta on 2/3/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import Foundation

// Global vars

var userDefaults = UserDefaults.standard

var residencePickerChoice: String? = userDefaults.object(forKey: "recyclingPref") as! String?
var recyclingDay: String? = userDefaults.object(forKey: "recyclingDay") as! String?

class Main: UIView {
    
    func setBlurredBackgroundImageWith(_ imageName: String, inViewController VC: UIViewController){
        
        let backgroundImage = UIImage(named: imageName)
        
        // Set amount of blur and apply to image
        let blurRad: CGFloat = 10.0
        let backgroundImageWithBlurEffect = UIImageEffects.imageByApplyingBlur(to: backgroundImage, withRadius: blurRad, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        let backgroundImageView = UIImageView(image: backgroundImageWithBlurEffect)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view of view controller in arg
        VC.view.addSubview(backgroundImageView)
        
        // Set scaling attribute and pin to view frame origin
        backgroundImageView.frame.origin = VC.view.frame.origin
        backgroundImageView.contentMode = .scaleAspectFit
        
        // Add top edge contraint
        let backgroundIVTopConstraint: NSLayoutConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: VC.view, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: 0)
        
        let backgroundIVLeftConstraint: NSLayoutConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: VC.view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        
        VC.view.addConstraints([backgroundIVTopConstraint, backgroundIVLeftConstraint])
        
        // Send blur image to back
        VC.view.sendSubview(toBack: backgroundImageView)
        
    }
    
}
