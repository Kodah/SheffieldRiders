//
//  LoginViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 11/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import SwiftSpinner

class LoginViewController: UIViewController {

    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboard()
        
        NSNotificationCenter.defaultCenter().addObserverForName("didSyncAllNotification", object: nil, queue: nil) {_ in
        
            SwiftSpinner.hide()
            if let window = UIApplication.sharedApplication().keyWindow
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewControllerWithIdentifier("mainNavController")
                window.rootViewController = mainVC
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func dismissView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        let info : NSDictionary = notification.userInfo!
        let kbFrame: NSValue = info.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        let animationDuration: NSTimeInterval = (info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!
        let keyboardFrame: CGRect = kbFrame .CGRectValue();
        
        let height: CGFloat = keyboardFrame.size.height
        
        self.keyboardHeight.constant = height
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }

    func keyboardWillHide(notification: NSNotification){
        let info : NSDictionary = notification.userInfo!
        let animationDuration: NSTimeInterval = (info.objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!
        self.keyboardHeight.constant = 0
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func logInButtonTapped(sender: AnyObject) {
        
        SwiftSpinner.show("Logging in")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let request = NSMutableURLRequest(URL: NSURL(string: Constants.apiBaseURL + "authentication")!)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonDictionary:[String:String] = ["username": self.usernameTextField.text!,
                                                  "password": self.passwordTextField.text!]
            do {
                let jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: [])
                request.HTTPBody = jsonBody
            } catch {
                print("Error")
            }
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error in
                guard data != nil else {
                    print("No response data")
                    SwiftSpinner.hide()
                    return
                }
                
                do {
                    let responseString = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! String
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.usernameTextField.text, forKey: Constants.LoggedInUser)
                    KeychainWrapper.setString(responseString, forKey: "authenticationToken")
                    SwiftSpinner.show("Syncing Data")
                    DataSynchroniser.sharedInstance.synchroniseAll()
                    
                } catch {
                    
                }
            }
            
            task.resume()
        }
        
        
    }
    
}
