//
//  WebViewController.swift
//  ATXwecycle
//
//  Created by Toph on 2/7/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var webView: WKWebView
    
    var yesNoPickerData = [String]()
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var yesNoPicker: UIPickerView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var isYourResidenceLabel: UILabel!
    
    // Initialize web view
    required init?(coder aDecoder: NSCoder) {
        
        self.webView = WKWebView(frame: CGRect.zero)
        
        super.init(coder: aDecoder)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.loadWebView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setContraintsForViews()
        
        // Format picker options
        yesNoPickerData = ["Yes", "No"]
        
        // Define picker delegate/datasource
        self.yesNoPicker.delegate = self
        self.yesNoPicker.dataSource = self
        
        // Initialize picker and set default picker choice in case ther is no event
        self.setDefaultPickerChoice()
        
        
    }

    // Send async request for recycle map url
    func loadWebView(){
        
        // Create session
        let session = URLSession.shared
        
        let url = URL(string: "https://www.austintexas.gov/sites/default/files/files/Resource_Recovery/RecyclingCalendar_2016_web_week-A.pdf")
        
        let request = URLRequest(url: url!)
        
        // Async request
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            self.webView.load(request)
            
        }) 
        
        dataTask.resume()
        
    }
    
    // Defines manual edge constraints in relation to screen size
    func setContraintsForViews(){
        
        self.view.addSubview(labelView)
        self.view.addSubview(webView)
        self.view.addSubview(yesNoPicker)
        
        labelView.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        yesNoPicker.translatesAutoresizingMaskIntoConstraints = false
        
        let labelViewHeightRatio: CGFloat = self.view.frame.height * 0.35
        
        
        // Set ht. for label view in terms of fraction of frame size
        let labelViewHeight = NSLayoutConstraint(item: labelView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: labelViewHeightRatio)
        
        
        // Set web view manual constraints
        let webViewTop = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: labelView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let webViewLeft = NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        
        let webViewRight = NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        
        let webViewBottom = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.view.addConstraints([labelViewHeight, webViewTop, webViewLeft, webViewRight, webViewBottom])
        
    }
    
    // If picker receives no event, below method will take care of a default choice (UIPicker delegate methods are fired only when they receive an event)
    func setDefaultPickerChoice(){
        
        // Manually set default picker value
        self.yesNoPicker.selectRow(0, inComponent: 0, animated: false)
        
        let row = self.yesNoPicker.selectedRow(inComponent: 0)
        
        residencePickerChoice = yesNoPickerData[row]
        
    }
    
    // MARK: -
    // MARK: Delegate Methods
    
    // The # of col. of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    // # of rows in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return yesNoPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return yesNoPickerData[row]
        
    }
    
    // Change picker text color attribute
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let options = yesNoPickerData[row]
        
        return NSAttributedString(string: options, attributes: [NSForegroundColorAttributeName:UIColor.white])
        
    }
    
    // Picker selection made (Note: Only when picker is moved. See default picker func for when no interaction is made)
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        residencePickerChoice = yesNoPickerData[row]
        
    }
    
    // MARK: -
    // MARK: IBActions
    
    // Action has manual segue connection from 'VC' yellow icon (above storyboard view) to ViewController. Segue created from button to said view would not trigger IBAction code block.
    @IBAction func nextBtnPressed(_ sender: AnyObject) {
        
        userDefaults.set(residencePickerChoice!, forKey: "recyclingPref")
        userDefaults.synchronize()
        
        self.performSegue(withIdentifier: "tomainvc", sender: self)
                
    }
    
}
