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
    
    
    let dateModel = DateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateModel.setUpRecycleDatesArray()
        
        self.formatYesOrNoLabelCorners()
        
        self.setBlurredBackgroundImage()
        
        self.dateModel.checkTodaysDateToRecycleDatesArray()
        
    }

    func setBlurredBackgroundImage(){
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundImage = UIImage(named: "lou neff pt.JPG")
        
        let blurRad: CGFloat = 45.0
        
        let backgroundImageWithBlurEffect = UIImageEffects.imageByApplyingBlurToImage(backgroundImage, withRadius: blurRad, tintColor: nil, saturationDeltaFactor: 1.0, maskImage: nil)
        
        let backgroundImageView = UIImageView(image: backgroundImageWithBlurEffect)
        
        self.view.addSubview(backgroundImageView)
        
        backgroundImageView.frame.size.width = self.view.frame.size.width
        backgroundImageView.frame.size.height = self.view.frame.size.height        
        
        backgroundImageView.contentMode = .ScaleAspectFit
        self.view.sendSubviewToBack(backgroundImageView)
        
    }
    
    func formatYesOrNoLabelCorners(){
        
        yesOrNoLabel.clipsToBounds = true
        yesOrNoLabel.layer.cornerRadius = 25
        
    }


}

