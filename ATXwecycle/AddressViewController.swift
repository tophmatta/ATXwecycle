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
import CoreLocation

//TODO: clean up view transitions once user finds recycling schedule, take out use of global variable and use singleton, Save pref. IBAction, UI design for address view (fix movement of stack views for collection day and schedule outlets), using mapkit or google maps API to have user allow use of location and use nearest address (if at home) to look up pref. rather than entering info, finish textfield event handling (touching outside of keyboard, adding done btn)

class AddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var streetTypeTextField: UITextField!
    @IBOutlet weak var collectionDayLabel: UILabel!
    @IBOutlet weak var collectionWeekLabel: UILabel!
    
    var locationManager:CLLocationManager!
    
    var streetType:String?
    var streetTypeData = ["", "ST", "RD", "DR", "LN", "CIR", "WAY", "TRL", "CV", "PL", "CT", "AVE", "BLVD", "PASS", "PATH", "LOOP", "RUN", "TER", "PKWY", "HOLW", "BND", "SKWY", "HWY", "GLN", "PARK", "XING", "ROW", "PT", "SQ", "WALK", "TRCE", "BRG", "VW", "VIEW", "CRES", "VALE", "PLZ", "SPUR"]
    
    let authStatus = CLLocationManager.authorizationStatus()
    
    let streetTypePickerView = UIPickerView()
    let globalFuncs = Main()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePicker()
        
        self.configureLocation()
        
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
        
    }
    
    //MARK: - CORE LOCATION
    func configureLocation(){
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        checkCoreLocationPermission()

        
    }
    
    func checkCoreLocationPermission(){
        
        
        switch authStatus {
        case .authorizedWhenInUse:
            print("Loc. already authorized")
        case .notDetermined:
            print("auth status not determined")
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestLocation()
        case .restricted:
            // put alert view explaining
            print("unauthorized to use location services")
        default:
            break
        }
        
    }
    
    //MARK: CL LOCATION MANAGER DELEGATE METHODS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if authStatus != .restricted {
            
            let latitude = locations.last?.coordinate.latitude
            let longitude = locations.last?.coordinate.longitude
            
            print("latitude: \(latitude); longitude: \(longitude)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("\(status)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        
    }

    
    //MARK: - STREET PICKER VIEW DATASOURCE & DELEGATE METHODS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return streetTypeData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return streetTypeData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        streetType = streetTypeData[row]
        
    }
    
    // Change picker text color attribute to white
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let options = streetTypeData[row]
        
        return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor.white])
        
    }
    
    //MARK: - UI ELEMENT METHODS
    // Action when done button pressed in street type picker toolbar
    func donePressed(){
        
        view.endEditing(true)
        
        streetTypeTextField.text = streetType
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
        
    }
    
    // Hittin up that 'Search' btn
    @IBAction func submitRequest(_ sender: AnyObject) {
        
        // Makes call to recycling schedule backend with completion handler
        self.hitAPI { (data, error) in
            
            let json = JSON(data!)
            let jsonCollectionDay = json[0]["collection_day"].string
            let jsonCollectionWeek = json[0]["collection_week"].string
            
            if jsonCollectionDay != nil && jsonCollectionWeek != nil {
                
                // Chose not to loop JSON to eliminate getting multiple dictionaries for multiple duplex/apt units (A,B,C,etc.) since only using street and address to find recycling schedule
                self.collectionDayLabel.text = jsonCollectionDay
                self.collectionWeekLabel.text = jsonCollectionWeek
                
            } else {
                
                // Alert msg
                let alert = UIAlertController.init(title: "Not Found", message: "Unable to locate address. Please try again.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func saveData(_ sender: AnyObject) {
        
        //TODO:
        
    }
    
    // Picker customization method
    
    func configurePicker(){
        
        // Manually set default picker value as first (blank) choice
        self.streetTypePickerView.selectRow(0, inComponent: 0, animated: false)
        
        let row = self.streetTypePickerView.selectedRow(inComponent: 0)
        
        // Set street type default (UIPickerViewDelegate methods called only when action received)
        streetType = streetTypeData[row]
        
        // Create instance of toolbar for modal street type picker view
        let toolbar = UIToolbar()
        
        // Add 'done' button and use flexible space to align it to right of toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Add button/space to toolbar
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        
        // This allows street type picker view to appear modally
        self.streetTypeTextField.inputView = streetTypePickerView
        
        // This goes above the modal street type picker view when street type text field is tapped
        self.streetTypeTextField.inputAccessoryView = toolbar
        
        // picker view color
        streetTypePickerView.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        
        streetTypePickerView.delegate = self
        streetTypePickerView.dataSource = self
        
    }
    
    
    //MARK: - API CALL METHOD
    func hitAPI(_ completionHandler: @escaping (Any?, Error?) -> ()){
        
        let toDoEndpoint: String = "https://data.austintexas.gov/resource/hp3m-f33e.json"
        
        let userHouseNum = numTextField.text ?? ""

        let userStreetName = streetTextField.text?.uppercased() ?? ""
        
        let userStreetType = streetType ?? ""
        
        if userStreetName == "" || userHouseNum == "" || userStreetType == "" {
            
            let alert = UIAlertController.init(title: "Not so fast", message: "Please fill out all fields", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let params = ["house_no":"\(userHouseNum)", "street_nam": "\(userStreetName)", "street_typ":"\(userStreetType)"]
            
            Alamofire.request(toDoEndpoint, method: .get, parameters: params)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        completionHandler(value, nil)
                        
                    case .failure(let error):
                        
                        completionHandler(nil, error)
                        
                    }
            }
            
        }
        
    }
    
    //UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1.0)
    
    
//    userDefaults.setObject(residencePickerChoice!, forKey: "recyclingPref")
//    userDefaults.synchronize()

}
