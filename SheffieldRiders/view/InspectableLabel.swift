//
//  InspectableLabel.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 29/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

@IBDesignable class InspectableLabel: UILabel {

    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
