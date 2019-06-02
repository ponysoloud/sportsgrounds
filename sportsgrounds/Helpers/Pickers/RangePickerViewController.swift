//
//  RangePickerViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 18/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import rubber_range_picker

extension UIAlertController {
    
    /// Add a date picker
    ///
    /// - Parameters:
    ///   - mode: date picker mode
    ///   - date: selected date of date picker
    ///   - minimumDate: minimum date of date picker
    ///   - maximumDate: maximum date of date picker
    ///   - action: an action for datePicker value change
    
    func addRangePicker(lowerValue: Int? = nil,
                        upperValue: Int? = nil,
                        minimumValue: Int,
                        maximumValue: Int,
                        action: RangePickerViewController.Action?) {
        
        let rangePicker = RangePickerViewController(lowerValue: lowerValue,
                                                    upperValue: upperValue,
                                                    minimumValue: minimumValue,
                                                    maximumValue: maximumValue,
                                                    action: action)
        set(vc: rangePicker, height: 100)
    }
}

final class RangePickerViewController: UIViewController {
    
    public typealias Action = (Int, Int) -> String?
    
    // MARK: - Private Properties
    
    private var action: Action?
    
    private lazy var label: UILabel = { [unowned self] in
        $0.font = UIFont.largeTextFont
        $0.textColor = UIColor.appBlack
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private lazy var rangePicker: RubberRangePicker = { [unowned self] in
        $0.thumbSize = 30.0
        $0.tintColor = .lightGray
        $0.lineColor = .appLightBlack
        $0.addTarget(self, action: #selector(RangePickerViewController.actionForRangePicker), for: .valueChanged)
        return $0
    }(RubberRangePicker())
    
    // MARK: - UIViewController Hierarchy
    
    required init(lowerValue: Int? = nil,
                  upperValue: Int? = nil,
                  minimumValue: Int,
                  maximumValue: Int,
                  action: Action?) {
        
        super.init(nibName: nil, bundle: nil)
        self.action = action
        
        self.rangePicker.minimumValue = Double(minimumValue)
        self.rangePicker.lowerValue = Double(lowerValue ?? minimumValue)
        
        self.rangePicker.maximumValue = Double(maximumValue)
        self.rangePicker.upperValue = Double(upperValue ?? maximumValue)
        
        self.label.text = self.action?(lowerValue ?? minimumValue, upperValue ?? maximumValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Private Functions
    
    private func setupSubviews() {
        view.addSubview(label)
        view.addSubview(rangePicker)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        rangePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15.0),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12.0),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12.0),
            
            rangePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20.0),
            rangePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0),
            rangePicker.heightAnchor.constraint(equalToConstant: 30.0),
            rangePicker.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60),
            rangePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15.0),
            rangePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0)
        ])
    }
    
    @objc private func actionForRangePicker() {
        let lower = Int(rangePicker.lowerValue)
        let upper = Int(rangePicker.upperValue)
        self.label.text = self.action?(lower, upper)
    }
}
