//
//  Segue.swift
//  ATXwecycle
//
//  Created by Toph on 9/27/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import Foundation

class Segue: UIStoryboardSegue {
    
    override func perform() {
        
        // Assign the source and destination views to local variables
        var sourceView = self.source.view as UIView
        var destinationView = self.destination.view as UIView
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destinationView, belowSubview: sourceView)
        
//        UIView.animate(withDuration: 1.0, animations: {
//            
//            }, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        
    }
    
}
