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

//TODO: clean up view transitions once user finds recycling schedule, take out use of global variable and use singleton?, Save pref. IBAction, UI design for address view (fix movement of stack views for collection day and schedule outlets), using mapkit or google maps API to have user allow use of location and use nearest address (if at home) to look up pref. rather than entering info, look up all street types in API data and write code to take out street types (Dr. or Drive, Rd. or Road, TER or terrace, etc.) - loop through dictionary, add street names to array, and discard duplicates

// STREET TYPES: ["ST", "LN", "CIR", "DR", "WAY", "TRL", "CV", "PL", "CT", "AVE", "BLVD", "RD", "PASS", "PATH", "LOOP", "RUN", "TER", "PKWY", "HOLW", "BND", "SKWY", "HWY", "GLN", "PARK", "XING", "ROW", "PT", "SQ", "WALK", "TRCE", "BRG", "VW", "VIEW", "CRES", "VALE", "PLZ", "SPUR"]


class AddressViewController: UIViewController {
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var collectionDayLabel: UILabel!
    @IBOutlet weak var collectionWeekLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func hitAPI(completionHandler: (AnyObject?, NSError?) -> ()){
        
        
        
        let todoEndpoint: String = "https://data.austintexas.gov/resource/hp3m-f33e.json"
        
        let userStreetName = streetTextField.text?.uppercaseString ?? ""
        
        let userHouseNum = numTextField.text ?? ""
        
        if userStreetName == "" || userHouseNum == "" {
            
            let alert = UIAlertController.init(title: "Not so fast", message: "Please fill out both house number and street name", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
            
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

            
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
            let jsonCollectionDay = json[0]["collection_day"].string
            let jsonCollectionWeek = json[0]["collection_week"].string

            if jsonCollectionDay != nil && jsonCollectionWeek != nil {
                
                // Chose not to loop JSON to eliminate getting multiple dictionaries for multiple duplex/apt units (A,B,C,etc.) since only using street and address to find recycling schedule
                self.collectionDayLabel.text = jsonCollectionDay
                self.collectionWeekLabel.text = jsonCollectionWeek
                
                //print("Your collection day is: \(json[0]["collection_day"]) \nYour collection schedule is: \(json[0]["collection_week"])")
                
                //print("Json: \(json)")
                
            } else {
                
                let alert = UIAlertController.init(title: "Not Found", message: "Unable to locate address. Please try again.", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                })
                
                alert.addAction(okAction)
                
                self.presentViewController(alert, animated: true, completion: nil)

                
            }
        }
    }
    
//    userDefaults.setObject(residencePickerChoice!, forKey: "recyclingPref")
//    userDefaults.synchronize()
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
