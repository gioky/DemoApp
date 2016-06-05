//
//  ViewController.swift
//  DemoApp
//
//  Created by George Kyriacou on 04/06/16.
//  Copyright © 2016 Macsha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    
    var pickerData: [String] = [String]()
    // initialize the PickerView
    let countryPicker = UIPickerView()
    
    @IBOutlet weak var carrierBtn: UIButton!
    @IBOutlet weak var countryTxtFld: UITextField!
    @IBOutlet weak var countryImgView: UIImageView!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var numberTxtFld: UITextField!
        
    var carrierName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        carrierBtn.layer.cornerRadius = 5
        carrierBtn.layer.borderWidth = 1
        
        // Connect data:
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        pickerData = ["Cyprus", "Greece"]
        
        // hides ui fields
        countryCodeLbl.hidden = true
        numberTxtFld.hidden = true
        carrierBtn.hidden = true
        
        // set the PickerView as input to the text field
        self.countryTxtFld.inputView = countryPicker
        
        // to move the keyboard up/down only for iphone 4s and 5
//        addKeyboardObservers()
    }
    
    
    func addKeyboardObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        adjustingHeight(true, notification: notification)
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        
        adjustingHeight(false, notification: notification)
    }
    
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        // 1
        var userInfo = notification.userInfo!
        
        let bounds = UIScreen.mainScreen().bounds
        let height = bounds.size.height
        
        // iphone 4s
        if (height == 480 && numberTxtFld.isFirstResponder()) {
            
            // 2
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            
            // 3
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            
            if (keyboardFrame.height == 216.0 && self.view.frame.origin.y == 0.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 270) * (show ? 1 : -1)
                // 5
                UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                    self.view.frame.origin.y += changeInHeight
                })
            }
            
            else if (keyboardFrame.height == 216.0 && self.view.frame.origin.y == -54.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 270) * (show ? 1 : -1)
                // 5
                
                if (changeInHeight != -54.0) {
                    UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                        self.view.frame.origin.y += changeInHeight
                    })
                }
                
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Dismiss the keyboard when the user taps outside of the UITextField
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    
    func getCarrier(country:String, number:String) {
        
        if (country == "Cyprus") {
            
            let firstChar = number[number.startIndex]
            
            if (firstChar == "9") {
                
                // Cyprus, Cyta
                carrierName = "Cyta"
                view.endEditing(true)
                self.performSegueWithIdentifier("showCarrier", sender: self)
            }
            
            else if (firstChar == "6") {
                
                // Cyprus, MTN
                carrierName = "MTN"
                view.endEditing(true)
                self.performSegueWithIdentifier("showCarrier", sender: self)
            }
            
            else {
                
                // no carrier found
                showAlert("No carrier found", message:"Please re-type your phone number and try again")
            }
            
        }
        
        
        else {
            
            // Get range of all characters past the first 6.
            let range = number.startIndex.advancedBy(0)..<number.endIndex.advancedBy(-6)
            let firstTwoChars = number[range]
            
            if (firstTwoChars == "72") {
                
                // Greece, Cosmote
                carrierName = "Cosmote"
                view.endEditing(true)
                self.performSegueWithIdentifier("showCarrier", sender: self)
            }
                
            else if (firstTwoChars == "44") {
                
                // Greece, Vodafone
                carrierName = "Vodafone"
                view.endEditing(true)
                self.performSegueWithIdentifier("showCarrier", sender: self)
            }
                
            else {
                
                // no carrier found
                showAlert("No carrier found", message:"Please re-type your phone number and try again")
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "showCarrier") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! CarrierViewController
            
            // pass the NSDate object to the property of the viewController
            viewController.viaSegueCountry = countryTxtFld.text!
            viewController.viaSegueNumber = numberTxtFld.text!
            viewController.viaSegueCarrier = carrierName;
            
        }
    
    }
    
    
    func showAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    //// IBActions ////
    
    @IBAction func carrierBtnClicked(sender: UIButton) {
        
        let numberString = numberTxtFld.text
        
        if (countryTxtFld.text == "Cyprus") {
            
            if (numberString?.characters.count == 0) {
                
                showAlert("Warning", message:"Please provide your phone number.")
            }
            else if (numberString?.characters.count != 7) {
                
                showAlert("Warning", message:"Number of digits should be 7")
            }
            else {
                
                getCarrier("Cyprus", number:numberTxtFld.text!)
            }
        }
        // Greece
        else {
            
            if (numberString?.characters.count == 0) {
                
                showAlert("Warning", message:"Please provide your phone number.")
            }
            else if (numberString?.characters.count != 8) {
                
                showAlert("Warning", message:"Number of digits should be 8")
            }
            else {
                
                getCarrier("Greece", number:numberTxtFld.text!)
            }
        }
        
    }
    
    //// END IBActions ////
    
    
    
    
    //// UIPickerView delegate methods ////
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        
        countryTxtFld.text = "\(pickerData[row])"
        
        if (pickerData[row] == "Cyprus") {
            
            countryImgView.image = UIImage(named: "cy_flag.png")
            countryCodeLbl.text = "+3579"
            numberTxtFld.text = ""
        }
        else {
            
            countryImgView.image = UIImage(named: "gr_flag.png")
            countryCodeLbl.text = "+3069"
            numberTxtFld.text = ""
        }
        
        // unhides ui fields
        countryCodeLbl.hidden = false
        numberTxtFld.hidden = false
        carrierBtn.hidden = false
    }
    

}

