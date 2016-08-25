//
//  AddressViewController.swift
//  ATXwecycle
//
//  Created by Toph on 8/16/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

//TODO: 1) clean up view transitions; once user finds recycling schedule, give option to save preference; take out use of global variable and use singleton?;

class AddressViewController: UIViewController {
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func hitAPI(completionHandler: (AnyObject?, NSError?) -> ()){
        
        
        
        let todoEndpoint: String = "https://data.austintexas.gov/resource/hp3m-f33e.json"
        
        let userStreetName = streetTextField.text?.uppercaseString ?? ""
        
        let userHouseNum = numTextField.text ?? ""
        
        if userStreetName == "" || userHouseNum == "" {
            
            print("Please fill in street # and street name")
            
        } else {
            
            let params = ["street_nam": "\(userStreetName)", "house_no":"\(userHouseNum)"]
            
            Alamofire.request(.GET, todoEndpoint, parameters: params)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .Success(let value):
                        
                        completionHandler(value, nil)
                        
                    case .Failure(let error):
                        
                        completionHandler(nil, error)
                        
                    }
            }
            
        }
        
        
    }

    @IBAction func submitRequest(sender: AnyObject) {
        
        // Makes call to recycling schedule backend with completion handler
        self.hitAPI { (data, error) in
            
            let json = JSON(data!)
            
            // Chose not to loop JSON to eliminate getting multiple dictionaries for multiple duplex/apt units (A,B,C,etc.) since only using street and address to find recycling schedule
            print("Your collection day is: \(json[0]["collection_day"]) \nYour collection schedule is: \(json[0]["collection_week"])")
            
            print("Json: \(json)")
            
            return
        }
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
