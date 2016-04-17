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
import Alamofire

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
        
        view.endEditing(true)
        
        let jsonDictionary:[String:String] = ["username": self.usernameTextField.text!,
                                              "password": self.passwordTextField.text!]
        
        Alamofire.request(.POST, Constants.apiBaseURL + "authentication", parameters: jsonDictionary, encoding: .JSON, headers: nil).responseJSON(completionHandler: { JSON in
            
            if let json = JSON.data {
                let responseJSON = try? NSJSONSerialization.JSONObjectWithData(json, options: .AllowFragments)
                if (JSON.response?.statusCode == 200) {
                    
                    NSUserDefaults.standardUserDefaults().setObject(self.usernameTextField.text, forKey: Constants.LoggedInUser)
                    KeychainWrapper.setString(responseJSON as! String, forKey: "authenticationToken")
                    SwiftSpinner.show("Syncing Data")
                    DataSynchroniser.sharedInstance.synchroniseAll()
                    
                } else {
                    SwiftSpinner.show("Failed", animated: false).addTapHandler({
                        SwiftSpinner.hide()
                    })
                }
            } else {
                SwiftSpinner.show("Failed", animated: false).addTapHandler({
                    SwiftSpinner.hide()
                })
            }
            print("login - Finished")
        })
    }

}
