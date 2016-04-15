//
//  OutlineTextLabel.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 15/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class OutlineTextLabel: UILabel {
    
    
    override func drawTextInRect(rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor
        
        let c = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(c, 2)
        CGContextSetLineJoin(c, .Round)
        
        CGContextSetTextDrawingMode(c, .Stroke)
        self.textColor = UIColor.blackColor()
        super.drawTextInRect(rect)
        
        CGContextSetTextDrawingMode(c, .Fill)
        self.textColor = textColor
        self.shadowOffset = CGSizeMake(0, 0)
        super.drawTextInRect(rect)
        
        self.shadowOffset = shadowOffset
        
    }
    


}
