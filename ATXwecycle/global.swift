//
//  global.swift
//  ATXwecycle
//
//  Created by Toph Matta on 2/3/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import Foundation

class Main: UIView {
    
    
    func setBlurredBackgroundImageWith(imageName: String, inViewController VC: UIViewController){
        
        VC.view.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImage = UIImage(named: imageName)
        
        let blurRad: CGFloat = 10.0
        
        let backgroundImageWithBlurEffect = UIImageEffects.imageByApplyingBlurToImage(backgroundImage, withRadius: blurRad, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        
        let backgroundImageView = UIImageView(image: backgroundImageWithBlurEffect)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        VC.view.addSubview(backgroundImageView)
        
        backgroundImageView.frame.origin = VC.view.frame.origin
        
        backgroundImageView.contentMode = .ScaleAspectFit
        
        let backgroundIVTopConstraint: NSLayoutConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: VC.view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0)
        
        VC.view.addConstraint(backgroundIVTopConstraint)
        
        VC.view.sendSubviewToBack(backgroundImageView)
        
    }
    
}