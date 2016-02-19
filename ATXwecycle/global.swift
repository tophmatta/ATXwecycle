//
//  global.swift
//  ATXwecycle
//
//  Created by Toph Matta on 2/3/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import Foundation

// Global vars
var residencePickerChoice: String? = userDefaults.objectForKey("recyclingPref") as! String?

var userDefaults = NSUserDefaults.standardUserDefaults()


class Main: UIView {
    
    func setBlurredBackgroundImageWith(imageName: String, inViewController VC: UIViewController){
        
        let backgroundImage = UIImage(named: imageName)
        
        // Set amount of blur and apply to image
        let blurRad: CGFloat = 10.0
        let backgroundImageWithBlurEffect = UIImageEffects.imageByApplyingBlurToImage(backgroundImage, withRadius: blurRad, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        let backgroundImageView = UIImageView(image: backgroundImageWithBlurEffect)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view of view controller in arg
        VC.view.addSubview(backgroundImageView)
        
        // Set scaling attribute and pin to view frame origin
        backgroundImageView.frame.origin = VC.view.frame.origin
        backgroundImageView.contentMode = .ScaleAspectFit
        
        // Add top edge contraint
        let backgroundIVTopConstraint: NSLayoutConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: VC.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
        
        VC.view.addConstraint(backgroundIVTopConstraint)
        
        // Send blur image to back
        VC.view.sendSubviewToBack(backgroundImageView)
        
    }
    
}