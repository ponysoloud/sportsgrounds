//
//  UIView+Extensions.swift
//  wallet
//
//  Created by  me on 26/07/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import UIKit

extension UIView {
    
    func simulateScalingOnTap(usingGestureRecognizer gestureRecognizer: UIGestureRecognizer,
                              withEvent event: @escaping () -> Void,
                              completion: @escaping () -> Void) {
        
        switch gestureRecognizer.state {
        case .began:
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = .init(scaleX: 0.95, y: 0.95)
            })
        case .ended:
            event()
            fallthrough
        case .cancelled, .failed:
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = .identity
            }, completion: {  _ in
                completion()
            })
        default:
            return
        }
    }
}

extension UIView {
    
    enum GradientDirection {
        case vertical
        case horizontal
        case diagonal
    }
    
    func fill(withGradient gradientColors: [UIColor], direction: GradientDirection, frame: CGRect? = nil) {
        let startPoint: CGPoint
        let endPoint: CGPoint
        
        switch direction {
        case .vertical:
            startPoint = CGPoint(x: 0.5, y: 0.0)
            endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .horizontal:
            startPoint = CGPoint(x: 0.0, y: 0.5)
            endPoint = CGPoint(x: 1.0, y: 0.5)
            
        case .diagonal:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        self.applyGradient(colors: gradientColors, frame: frame, startPoint: startPoint, endPoint: endPoint)
    }

    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, frame: CGRect? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = frame ?? bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations

        if let startPoint = startPoint, let endPoint = endPoint {
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {

    @objc
    func beginLoading(withOffset offset: CGFloat = 0.0) {
        endLoading()

        let rect = CGRect(x: 0.0, y: 0.0, width: 60.0, height: 60.0)
        let loadingView = UIView(frame: rect)

        loadingView.center = center
        loadingView.layer.sublayers = nil

        let animationFrame = CGRect(x: 0, y: 0, width: 60.0, height: 60.0)
        let animation = SGSpinningAnimationLayer(frame: animationFrame, color: .appBlack, lineWidth: 4.0)
        animation.animate()

        loadingView.layer.addSublayer(animation)
        loadingView.tag = 121514

        alpha = 0.5

        superview?.insertSubview(loadingView, aboveSubview: self)

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
    }

    @objc
    func endLoading() {
        alpha = 1.0

        let loadingView = superview?.viewWithTag(121514)
        loadingView?.removeFromSuperview()
    }
}

extension UIView {

    @IBInspectable
    /// Border color of view; also inspectable from Storyboard.
    public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }

    @IBInspectable
    /// Border width of view; also inspectable from Storyboard.
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    /// Shadow color of view; also inspectable from Storyboard.
    public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    @IBInspectable
    /// Shadow offset of view; also inspectable from Storyboard.
    public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    /// Shadow opacity of view; also inspectable from Storyboard.
    public var shadowOpacity: Double {
        get {
            return Double(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }

    @IBInspectable
    /// Shadow radius of view; also inspectable from Storyboard.
    public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    /// Shadow path of view; also inspectable from Storyboard.
    public var shadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }

    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowShouldRasterize: Bool {
        get {
            return layer.shouldRasterize
        }
        set {
            layer.shouldRasterize = newValue
        }
    }

    @IBInspectable
    /// Should shadow rasterize of view; also inspectable from Storyboard.
    /// cache the rendered shadow so that it doesn't need to be redrawn
    public var shadowRasterizationScale: CGFloat {
        get {
            return layer.rasterizationScale
        }
        set {
            layer.rasterizationScale = newValue
        }
    }

    @IBInspectable
    /// Corner radius of view; also inspectable from Storyboard.
    public var maskToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}


// MARK: - Properties

public extension UIView {

    /// Size of view.
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
    }

    /// Width of view.
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }

    /// Height of view.
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
}

extension UIView {

    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: T.self) }
    }

}


// MARK: - Methods

public extension UIView {

    typealias Configuration = (UIView) -> Swift.Void

    func config(configurate: Configuration?) {
        configurate?(self)
    }

    /// Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}

extension UIView {

    func searchVisualEffectsSubview() -> UIVisualEffectView? {
        if let visualEffectView = self as? UIVisualEffectView {
            return visualEffectView
        } else {
            for subview in subviews {
                if let found = subview.searchVisualEffectsSubview() {
                    return found
                }
            }
        }
        return nil
    }

    /// This is the function to get subViews of a view of a particular type
    /// https://stackoverflow.com/a/45297466/5321670
    func subviews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }


    /// This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T
    /// https://stackoverflow.com/a/45297466/5321670
    func allSubviewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
