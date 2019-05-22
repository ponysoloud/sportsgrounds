//
//  SGTextField.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTextField: SGInsetedTextField {
    
    static var textField: SGTextField {
        let textField = SGTextField()
        textField.insetX = 18.0
        textField.font = UIFont.mediumTextFont
        textField.textColor = UIColor.appBlack
        
        return textField
    }
    
    override var placeholder: String? {
        get {
            return attributedPlaceholder?.string
        }
        set {
            if let newPlaceholder = newValue {
                self.attributedPlaceholder = NSAttributedString(string: newPlaceholder,
                                                                attributes: attributedPlaceholderAttributes)
            } else {
                self.attributedPlaceholder = nil
            }
        }
    }
    
    private var attributedPlaceholderAttributes: [NSAttributedString.Key: Any] {
        return [.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.appLightBlack]
    }
}
