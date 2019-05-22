//
//  OnboardingPageViewController.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGOnboardingPageViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
        }
    }
    
    override var title: String? {
        get {
            return titleLabel.text
        }
        
        set {
            titleLabel.text = newValue
        }
    }
    
    var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        
        set {
            subtitleLabel.text = newValue
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var imageContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        imageContainerView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var textContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.titleFont
        
        textContainerView.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.largeTextFont
        
        textContainerView.addSubview(label)
        return label
    }()
    
    // MARK: - UIViewController's Lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addConstraintsToSubviews()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.addConstraintsToSubviews()
    }
    
    // MARK: - Private Functions
    
    private func addConstraintsToSubviews() {
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        subtitleLabel.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
        
        var topMargin: CGFloat {
            return UIScreen.main.bounds.height / 7
        }
        
        var horizontalMargin: CGFloat {
            return 36.0 > UIScreen.main.bounds.width / 10 ? 15.0 : 36.0
        }
        
        var textHeight: CGFloat {
            return UIScreen.main.bounds.height / 6.5
        }
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25.0),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin),
            
            imageView.leftAnchor.constraint(greaterThanOrEqualTo: imageContainerView.leftAnchor),
            imageView.rightAnchor.constraint(lessThanOrEqualTo: imageContainerView.rightAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: imageContainerView.bottomAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            textContainerView.heightAnchor.constraint(equalToConstant: textHeight),
            textContainerView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 32.0),
            textContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalMargin),
            textContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalMargin),
            textContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            
            titleLabel.topAnchor.constraint(equalTo: textContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: textContainerView.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: textContainerView.bottomAnchor)
        ])
    }
}
