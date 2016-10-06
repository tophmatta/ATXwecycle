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

//TODO: clean up view transitions once user finds recycling schedule, take out use of global variable and use singleton, Save pref. IBAction, finish textfield event handling (adding done btn), dim User loc button when location use is denied, handle tap of use loc. button using 'open settings' choice in alert controller (http://nshipster.com/core-location-in-ios-8/)

// Note: You spent a lot of time using core loc for the first time and then later found out the problem was not adding a value into the .plist file for type of location use.
class AddressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var streetTypeTextField: UITextField!
    @IBOutlet weak var collectionDayLabel: UILabel!
    @IBOutlet weak var collectionWeekLabel: UILabel!
    
    @IBOutlet weak var useLocBtn: UIButton!
    
    lazy var locationManager = CLLocationManager()
    
    var streetType:String?
    var streetTypeData = ["", "ST", "RD", "DR", "LN", "CIR", "WAY", "TRL", "CV", "PL", "CT", "AVE", "BLVD", "PASS", "PATH", "LOOP", "RUN", "TER", "PKWY", "HOLW", "BND", "SKWY", "HWY", "GLN", "PARK", "XING", "ROW", "PT", "SQ", "WALK", "TRCE", "BRG", "VW", "VIEW", "CRES", "VALE", "PLZ", "SPUR"]
    
    let streetTypePickerView = UIPickerView()
    let globalFuncs = Main()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePicker()
        self.addDoneButtonOnKeyboard(textField: streetTypeTextField)
        self.addDoneButtonOnKeyboard(textField: streetTextField)
        self.addDoneButtonOnKeyboard(textField: numTextField)
        
        self.checkCoreLocationPermission()
        
        self.globalFuncs.setBlurredBackgroundImageWith("SouthRimStanding.jpg", inViewController: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
    }
    
    
    
    @objc func applicationDidBecomeActive(){
        
        locationManager.delegate = self
        
        print("active")
    }
    
    //MARK: - CORE LOCATION
    
    func checkCoreLocationPermission(){

        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            useLocBtn.alpha = 1.0
            print("auth stat - when in use")
            
        case .notDetermined, .restricted:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            useLocBtn.alpha = 0.5
            print("auth stat - nd")
            
        case .denied:
            print("denied")
            useLocBtn.alpha = 0.5
            
        default:
            break
        }
        
    }

    @IBAction func useLoc(_ sender: AnyObject) {
        
        if useLocBtn.alpha == 0.5 {
            
            // Alert msg w/ 'open settings'
            let alert = UIAlertController.init(title: "Background Location Access Disabled", message: "In order to auto-populate your address info into the fields, please open the app settings and set location access to 'While In Use'.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    
                    UIApplication.shared.openURL(url as URL)
                    
                }
            })
            
            alert.addAction(openAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        numTextField.text = ""
        streetTextField.text = ""
        streetTypeTextField.text = ""
        
        
        CLGeocoder().reverseGeocodeLocation(locationManager.location!) { (placemarks, error) in
            
            if placemarks != nil {
                
                let pm = placemarks![0] as CLPlacemark
                
                let roadWithStreetType = pm.thoroughfare?.uppercased()
                
                // Obtain where first space occurs from endIndex backwards and remove the st. type and vice versa w/ the street name to produce the data separately.
                
                // Handles full street name/type and slices it into array street and street type for API call (e.g. "Ashwood Rd." => ["ASHWOOD", "RD"].
                if let rwst = roadWithStreetType {
                    
                    // Take string w/ multiple substrings and creates array of separate strings elements
                    let stringReplaceSpaceAndPeriod = rwst.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: " ", with: ",")
                    let arr = stringReplaceSpaceAndPeriod.characters.split(separator: ",")
                    let mappedArr = arr.map(String.init)
                    
                    // Store street type
                    let streetTypeCL = mappedArr.last!
                    
                    // Remove from array
                    let mappedArrRemoveStType = mappedArr.dropLast()
                    
                    // Join remaining substrings to put togther entire street name
                    let streetNameCL = mappedArrRemoveStType.joined(separator: " ")
                    
                    self.streetTextField.text = streetNameCL
                    self.streetTypeTextField.text = streetTypeCL
                    self.streetType = streetTypeCL
                    
                    // Populates house #
                    self.numTextField.text = pm.subThoroughfare

                } else {
                    
                    // Alert msg
                    let alert = UIAlertController.init(title: "Problem using location", message: "Please try again or manually enter in address info", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkCoreLocationPermission()
        
        print("did change auth status")
        
        
    }
    
    @IBAction func clearBtn(_ sender: AnyObject) {
        
        numTextField.text = ""
        streetTextField.text = ""
        streetTypeTextField.text = ""
        streetType = nil
        
        collectionDayLabel.text = ""
        collectionWeekLabel.text = ""
        
        
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
    //TODO: save data
    @IBAction func saveData(_ sender: AnyObject) {
        
        
        
    }
    
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        
        let keyboardToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keyboardToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        keyboardToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keyboardToolbar
        
        textField.autocorrectionType = .no
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
            
            let alert = UIAlertController.init(title: "Not So Fast", message: "Please fill out all fields", preferredStyle: .alert)
            
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
