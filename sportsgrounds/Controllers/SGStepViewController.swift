//
//  SGStepViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 18/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGStepViewController: SGViewController {
    
    override var title: String? {
        get {
            return self.titleLabel.text
        }
        
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var subtitle: String? {
        get {
            return self.subtitleLabel.text
        }
        
        set {
            self.subtitleLabel.text = newValue
        }
    }
    
    var arrangedSubviews: [UIView] {
        get {
            return self.stackView.arrangedSubviews
        }
        
        set {
            self.stackView.removeAllArrangedSubviews()
            newValue.forEach {
                self.stackView.addArrangedSubview($0)
            }
        }
    }
    
    var isButtonEnabled: Bool {
        get {
            return self.button.isEnabled
        }
        
        set {
            self.button.isEnabled = newValue
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.titleFont
        
        view.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.largeTextFont
        
        view.addSubview(label)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 4.0
        
        view.addSubview(stackView)
        return stackView
    }()
    
    private lazy var errorLabel: SGErrorLabel = {
        let label = SGErrorLabel.label
        label.textInsets = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 0)
        
        stackView.addArrangedSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = SGButton.button
        button.setTitle("Продолжить", for: .normal)
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addConstraintsToSubviews()
        self.addGestureRecognizerForHidingKeyboardOnTap()
        
        self.view.backgroundColor = UIColor.appWhite
    }
    
    // MARK: - Private Functions
    
    private func addConstraintsToSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        subtitleLabel.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
        
        errorLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27.0)
        topConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            topConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36.0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36.0),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 27.0),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            button.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 16.0),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    // MARK: - Public Functions
    
    func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
    
    func removeArrangedSubview(_ view: UIView) {
        view.removeFromSuperview()
    }
    
    @objc func buttonTouchUpInside(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

