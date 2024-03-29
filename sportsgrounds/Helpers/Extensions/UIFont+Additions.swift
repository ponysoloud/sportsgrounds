//
//  UIFont+Additions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var titleFont: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    class var title3Font: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    class var subtitle1Font: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    class var subtitle2Font: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    class var subtitle3Font: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    class var subtitle4Font: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    
    class var largeTextFont: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    
    class var mediumTextFont: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    class var smallTextFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    class var descriptionTextFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    class var supersmallTextFont: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .medium)
    }
}
