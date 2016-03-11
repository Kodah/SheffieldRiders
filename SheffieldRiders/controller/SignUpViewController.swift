//
//  SignUpViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 11/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit


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
                "password": password!,
                "email": "ste@s.com"
            ]
        }
        return reqBody
    }
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.apiBaseURL + "register")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dic = createRequestBody()
        do {
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions.PrettyPrinted)
            
            request.HTTPBody = jsonData
        } catch let error as NSError {
            print(error)
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print(json.valueForKeyPath("errors.*.message"))

            } catch {}
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                var errorMessages = ""
//                print(responseString)
//                for error in response?.valueForKey("errors") as! [Dictionary<String, String>] {
//                    errorMessages.appendContentsOf(error["message"]!)
//                }
//                
//                let alert = UIAlertController(title: "Error", message: errorMessages, preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        task.resume()
        
    }
    
}
