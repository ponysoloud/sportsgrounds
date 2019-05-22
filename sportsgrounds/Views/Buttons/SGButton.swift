//
//  SGButton.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGButton: UIButton {
    
    static var button: SGButton {
        let button = SGButton(type: .custom)
        button.setBackgroundImage(UIImage.image(withColor: UIColor.appBlue), for: .normal)
        button.setBackgroundImage(UIImage.image(withColor: UIColor.appBlue.withAlphaComponent(0.8)), for: .highlighted)
        button.setBackgroundImage(UIImage.image(withColor: UIColor.appBlue.withAlphaComponent(0.4)), for: .disabled)
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.titleLabel?.font = UIFont.subtitle1Font
        button.setTitleColor(UIColor.appWhite, for: .normal)
        
        button.layer.masksToBounds = true
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.height / 2.0
    }
}
