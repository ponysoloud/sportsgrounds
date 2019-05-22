//
//  SGBallLayer.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGBallLayer: CAShapeLayer {
    
    init(frame: CGRect, color: UIColor) {
        super.init()
        
        let path: UIBezierPath = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: frame.size.width / 2,
                                        y: frame.size.height / 2),
                    radius: frame.size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)
        
        self.fillColor = color.cgColor
        
        self.path = path.cgPath
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

