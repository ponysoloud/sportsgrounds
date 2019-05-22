//
//  SGTextView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTextView: UITextView {
    
    static var textView: SGTextView {
        let textView = SGTextView()
        textView.textColor = UIColor.appBlack
        textView.font = UIFont.mediumTextFont
        
        textView.backgroundColor = UIColor.appLightBlack
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.masksToBounds = true
        
        return textView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height / 2
    }
}
