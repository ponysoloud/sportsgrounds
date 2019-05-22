//
//  SGErrorLabel.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGErrorLabel: SGInsetedLabel {
    
    static var label: SGErrorLabel {
        let label = SGErrorLabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.descriptionTextFont
        label.textColor = UIColor.appError
        
        return label
    }
    
}
