//
//  UITextField+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
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
