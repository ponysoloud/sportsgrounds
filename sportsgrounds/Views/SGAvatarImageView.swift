//
//  SGAvatarImageView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGAvatarImageView: UIImageView {
    
    static var imageView: SGAvatarImageView {
        let imageView = SGAvatarImageView(image: UIImage(named: "user.avatar.placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.maskToBounds = true
        
        return imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.height / 2.0
    }
}

