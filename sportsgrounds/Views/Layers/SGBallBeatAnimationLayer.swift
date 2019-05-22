//
//  SGBallBeatAnimationLayer.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGBallBeatAnimationLayer: CALayer {
    
    private let ballCount: Int = 3
    private let ballColor: UIColor
    
    init(frame: CGRect, ballColor: UIColor) {
        self.ballColor = ballColor
        super.init()
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.ballColor = UIColor.appWhite
        super.init(coder: aDecoder)
    }
    
    func animate() {
        let ballSize: CGFloat = self.frame.size.height
        let x: CGFloat = 0.0
        let y: CGFloat = 0.0
        let duration: CFTimeInterval = 0.7
        let beginTime = CACurrentMediaTime()
        let beginTimes = [0.35, 0, 0.35]
        let ballSpacing = (self.frame.size.width - ballSize * CGFloat(ballCount)) / CGFloat(ballCount - 1)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 0.75, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.keyTimes = [0, 0.5, 1]
        opacityAnimation.values = [1, 0.2, 1]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circles
        for i in 0..<ballCount {
            let ball = SGBallLayer(frame: CGRect(x: x + ballSize * CGFloat(i) + ballSpacing * CGFloat(i),
                                                 y: y,
                                                 width: ballSize,
                                                 height: ballSize),
                                   color: ballColor)
            
            animation.beginTime = beginTime + beginTimes[i]
            ball.add(animation, forKey: "animation")
            self.addSublayer(ball)
        }
    }
}
