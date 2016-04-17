//
//  UpdateProfileViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 15/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import SwiftSpinner

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var disciplineTextField: UITextField!
    
    var quote: String?
    var discipline: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        quoteTextField.text = quote
        disciplineTextField.text = discipline
    }
    

    @IBAction func updateTapped(sender: AnyObject) {
        
        SwiftSpinner.show("Updating", animated: true)
        
        if (quoteTextField.text != quote) {
            DataSynchroniser.sharedInstance.updateQuote(quoteTextField.text!, callBack: {
                
                if self.disciplineTextField.text != self.discipline {
                    DataSynchroniser.sharedInstance.updateDiscipline(self.disciplineTextField.text!, callBack: { 
                        self.didEndUpdating()
                    })
                } else {
                    self.didEndUpdating()
                }
            })
        } else if (self.disciplineTextField.text != self.discipline) {
            DataSynchroniser.sharedInstance.updateDiscipline(self.disciplineTextField.text!, callBack: {
                self.didEndUpdating()
            })
        }
        else {
            didEndUpdating()
        }
    }
    
    func didEndUpdating(){
        SwiftSpinner.show("Profile Updated", animated: false)
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            SwiftSpinner.hide()
            self.dismissViewControllerAnimated(true, completion: nil)
        }


    }

    @IBAction func cancelTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
