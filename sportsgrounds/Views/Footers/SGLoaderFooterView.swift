//
//  SGLoaderFooterView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGLoaderFooterView: UIView {
    
    private lazy var loadingLayer: SGBallBeatAnimationLayer = {
        let layer = SGBallBeatAnimationLayer(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: 120,
                                                           height: 25),
                                             ballColor: UIColor.appLightBlack)
        self.layer.addSublayer(layer)
        return layer
    }()
    
    // MARK: - UITableViewCell Hierarchy
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingLayer.frame = CGRect(x: (self.width - 120) / 2, y: 15, width: 120, height: 25)
    }
    
    // MARK: - Public functions
    
    static var height: CGFloat {
        return 55.0
    }
    
    func animate() {
        self.loadingLayer.animate()
    }
}
