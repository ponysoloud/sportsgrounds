//
//  UIImage+Extensions.swift
//  wallet
//
//  Created by  me on 13/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    static func gradientImage(colors: [UIColor], locations: [NSNumber]?, frame: CGRect) -> UIImage {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations

        UIGraphicsBeginImageContext(frame.size)

        gradient.render(in: UIGraphicsGetCurrentContext()!)

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage!
    }

    static func qrCode(from string: String, size: CGSize) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            guard let output = filter.outputImage else {
                return nil
            }

            let result = UIImage(ciImage: output)

            let scaleX = size.width / result.size.width
            let scaleY = size.height / result.size.height

            guard let transformedImage = result.ciImage?.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY)) else {
                return nil
            }

            return UIImage(ciImage: transformedImage)
        }

        return nil
    }
}

extension UIImage {
    
    static func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func maskWithColor(color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        
        color.setFill()
        self.draw(in: rect)
        
        context.setBlendMode(.sourceIn)
        context.fill(rect)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
}
