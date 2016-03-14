//
//  LoginViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 11/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboard()
    }
    
    override func viewDidAppear(animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    func observeKeyboard() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.apiBaseURL + "authentication")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDictionary:[String:String] = ["username": usernameTextField.text!,
            "password": passwordTextField.text!]
        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonDictionary, options: [])
                request.HTTPBody = jsonBody
        } catch {
            print("Error")
        }
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error in
            guard data != nil else {
                print("No response data")
                return
            }
            
            do {
                let responseString = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! String
                
                
                
                let saveSuccessful: Bool = KeychainWrapper.setString(responseString, forKey: "authenticationToken")

//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    self.performSegueWithIdentifier("SegToMainStoryboard", sender: self)
//                        
//                })


                
                

                // save token in keychain
                // dismiss login view controller
                // load main app storyboard and present
                
                print(responseString, saveSuccessful)
            } catch {
                
            }
        }
        
        task.resume()
    }
    
}
