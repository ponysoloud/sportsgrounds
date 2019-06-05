//
//  UIColor+Additions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc class var appBlue: UIColor {
        return UIColor(red: 31, green: 138, blue: 255)
    }
    
    @nonobjc class var appBlack: UIColor {
        return UIColor(red: 75, green: 74, blue: 85)
    }
    
    @nonobjc class var appSecondaryBlack: UIColor {
        return UIColor(red: 75, green: 74, blue: 85, transparency: 0.4)
    }
    
    @nonobjc class var appLightBlack: UIColor {
        return UIColor(red: 75, green: 74, blue: 85, transparency: 0.1)
    }
    
    @nonobjc class var appWhite: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var appWhiteTransparent: UIColor {
        return UIColor.white.withAlphaComponent(0.4)
    }
    
    @nonobjc class var appGray: UIColor {
        return UIColor(red: 247, green: 247, blue: 247)
    }
    
    @nonobjc class var appLightGray: UIColor {
        return UIColor(red: 237, green: 237, blue: 237)
    }
    
    @nonobjc class var appError: UIColor {
        return UIColor(red: 248, green: 92, blue: 92)
    }
    
    @nonobjc class var greenGradient: [UIColor] {
        return [UIColor(red: 89, green: 233, blue: 222), UIColor(red: 59, green: 233, blue: 177)]
    }
    
    @nonobjc class var blueGradient: [UIColor] {
        return [UIColor(red: 127, green: 206, blue: 254), UIColor(red: 78, green: 171, blue: 254)]
    }
}
