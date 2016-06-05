//
//  CarrierViewController.swift
//  DemoApp
//
//  Created by George Kyriacou on 04/06/16.
//  Copyright © 2016 Macsha. All rights reserved.
//

import UIKit

class CarrierViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var carrierImgView: UIImageView!
    @IBOutlet weak var countryImgView: UIImageView!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var carrierLbl: UILabel!
    @IBOutlet weak var phoneNoLbl: UILabel!
    @IBOutlet weak var sendSmsBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var viaSegueCountry = ""
    var viaSegueNumber = ""
    var viaSegueCarrier = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // conform to the delegate
        textView.delegate = self
        
        sendSmsBtn.layer.cornerRadius = 5
        sendSmsBtn.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        
        countryLbl.text = viaSegueCountry
        carrierLbl.text = viaSegueCarrier
        
        applyFlagsAndCode()
        
        // to move the keyboard up/down only for iphone 4s and 5
        addKeyboardObservers()
    }
    
    
    func addKeyboardObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CarrierViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CarrierViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
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
        
        // iphone 5
        if (height == 568) {
            
            // 2
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            // 3
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            
            // keyboard height + word suggestion bar
            if (keyboardFrame.height == 253.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 350) * (show ? 1 : -1)
                // 5
                UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                    self.view.frame.origin.y += changeInHeight
                })
            }
                
            else if (keyboardFrame.height == 216.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 270) * (show ? 1 : -1)
                // 5
                UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                    self.view.frame.origin.y += changeInHeight
                })
            }
        }
            
        // iphone 4s
        else if (height == 480) {
            
            // 2
            let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
            
            // 3
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            
            // keyboard height + word suggestion bar
            if (keyboardFrame.height == 253.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 430) * (show ? 1 : -1)
                // 5
                UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                    self.view.frame.origin.y += changeInHeight
                })
            }
                
            else if (keyboardFrame.height == 216.0) {
                
                // 4
                let changeInHeight = (CGRectGetHeight(keyboardFrame) - 350) * (show ? 1 : -1)
                // 5
                UIView.animateWithDuration(animationDurarion, animations: { () -> Void in
                    self.view.frame.origin.y += changeInHeight
                })
            }
        }
        
    }
    
    
    func applyFlagsAndCode() {
        
        if (viaSegueCountry == "Greece") {
            
            countryImgView.image = UIImage(named: "gr_flag.png")
        }
        else {
            countryImgView.image = UIImage(named: "cy_flag.png")
        }
        
        
        if (viaSegueCarrier == "Cosmote")  {
            
            carrierImgView.image = UIImage(named: "cosmote.png")
            viaSegueNumber = "+30 69 " + viaSegueNumber
            phoneNoLbl.text = viaSegueNumber
        }
            
        else if (viaSegueCarrier == "Vodafone") {
            
            carrierImgView.image = UIImage(named: "vodafone.png")
            viaSegueNumber = "+30 69 " + viaSegueNumber
            phoneNoLbl.text = viaSegueNumber
        }
            
        else if (viaSegueCarrier == "Cyta") {
            
            carrierImgView.image = UIImage(named: "cyta.png")
            viaSegueNumber = "+ 357 9" + viaSegueNumber
            phoneNoLbl.text = viaSegueNumber
        }
            
        else if (viaSegueCarrier == "MTN") {
            
            carrierImgView.image = UIImage(named: "mtn.png")
            viaSegueNumber = "+ 357 9" + viaSegueNumber
            phoneNoLbl.text = viaSegueNumber
        }
    }
    
    
    @IBAction func sendSmsBtnClicked(sender: UIButton) {
        
        if (textView.text.characters.count != 0) {
            
            self.view.endEditing(true)
            showSuccessAlert()
        }
        else {
            
            self.view.endEditing(true)
            showAlert("Warning", message: "No characters entered. Message cannot be send.")
        }
    }
    
    
    func showAlert(title: String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func showSuccessAlert() {
        
        let todaysDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let currentDateTime = dateFormatter.stringFromDate(todaysDate)
        
        let alertContr = UIAlertController(title: "Message Sent", message: "{success : [{ sender : Netsmart, receiver : \(viaSegueNumber), attributes : { timestamp : \(currentDateTime) , body : xxxxxxxxxx, provider : \(viaSegueCarrier) }}]}", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertContr.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok logic here")
            self.textView.text = ""
        }))
        
        presentViewController(alertContr, animated: true, completion: nil)
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
    
    
    
    //// UITextView delegate methods ////
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 161;
    }
    
    
    
}
