//
//  TranslucentTextField.swift
//  SharePics
//
//  Created by Praneet Jain on 6/25/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class TranslucentTextField : UITextField{

    required init?(coder aDecoder: NSCoder) {
        placeholderText = ""
        super.init(coder: aDecoder)
        tintColor = UIColor.white
        layer.cornerRadius = 3
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    var placeholderText : String{
        didSet{
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName : UIColor(white : 1.0, alpha: 0.7)])
        }
    }
}
