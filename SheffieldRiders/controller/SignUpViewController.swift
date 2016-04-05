//
//  SignUpViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 11/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passRepeatTextfield: UITextField!
    
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
    
    func createRequestBody() -> Dictionary<String, String> {
        var reqBody = [String: String]()
        
        if (usernameTextField.text == "" || passwordTextField.text == "")
        {
            let alert = UIAlertController(title: "Alert", message: "Missing information", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else if (passwordTextField.text != passRepeatTextfield.text) {
            let alert = UIAlertController(title: "Alert", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let username = usernameTextField.text
            let password = passwordTextField.text
            
            reqBody = [
                "username": username!,
                "password": password!
            ]
        }
        return reqBody
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        let dic = createRequestBody()
        SwiftSpinner.show("Attempting registeration")
        
        Alamofire.request(.POST, Constants.apiBaseURL + "register", parameters: dic, encoding: .JSON, headers: nil).responseJSON(completionHandler: { JSON in
            
            let responseJSON = try! NSJSONSerialization.JSONObjectWithData(JSON.data!, options: .AllowFragments)
            if (JSON.response?.statusCode == 200) {
                
                
                SwiftSpinner.show(responseJSON.description, animated: false).addTapHandler({
                    SwiftSpinner.hide()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                })
            } else {
                SwiftSpinner.show("Server Error").addTapHandler({
                    SwiftSpinner.hide()
                })
            }
            
            print("Signup - Finished")

        })
    }
    
}
