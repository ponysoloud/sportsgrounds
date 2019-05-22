//
//  SGSeparatorView.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGSeparatorView: UIView {
    
    static var view: SGSeparatorView {
        let view = SGSeparatorView()
        view.backgroundColor = UIColor.appLightBlack
        
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.height / 2.0
    }
}
