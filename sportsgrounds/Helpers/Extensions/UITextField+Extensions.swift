//
//  UITextField+Extensions.swift
//  wallet
//
//  Created by  me on 27/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UITextField {

    var leftPadding: CGFloat {
        get {
            return leftView?.frame.size.width ?? 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.size.height))
            leftView = paddingView
            leftView?.frame.size.width = newValue
            leftViewMode = .always
            leftView?.isUserInteractionEnabled = false
        }
    }

    var rightPadding: CGFloat {
        get {
            return rightView?.frame.size.width ?? 0.0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.size.height))
            rightView = paddingView
            rightView?.frame.size.width = newValue
            rightViewMode = .always
            rightView?.isUserInteractionEnabled = false
        }
    }
}
