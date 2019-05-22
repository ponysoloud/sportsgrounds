//
//  SGCircleButton.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGLocationButton: UIButton {
    
    static var button: SGLocationButton {
        let button = SGLocationButton(type: .custom)
        button.setImage(UIImage(named: "map.icon.location.enabled"), for: .selected)
        button.setImage(UIImage(named: "map.icon.location.disabled"), for: .normal)
        button.setImage(UIImage(named: "map.icon.location.disabled"), for: .disabled)
        button.setBackgroundImage(UIImage.image(withColor: .appWhite), for: .normal)
        button.setBackgroundImage(UIImage.image(withColor: .lightGray), for: .highlighted)
        button.layer.masksToBounds = true
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height / 2.0
    }
}

class SGLocationView: UIView {
    
    static var view: SGLocationView {
        let view = SGLocationView()
        view.backgroundColor = .clear
        
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.2
        
        let button = SGLocationButton.button
        view.locationButton = button
        view.addSubview(button)
        return view
    }
    
    var locationButton: SGLocationButton?
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.locationButton?.frame = self.bounds
        self.layer.cornerRadius = self.height / 2.0
    }
}
