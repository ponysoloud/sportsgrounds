//
//  SGGroundCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGGroundCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle1Font
        label.textAlignment = .left
        label.numberOfLines = 0
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .mediumTextFont
        label.textAlignment = .left
        label.numberOfLines = 0
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var activitiesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private lazy var environmentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private func button(withIcon icon: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(icon, for: .normal)
        button.contentEdgeInsets = .zero
        button.imageEdgeInsets = .zero
        
        button.isUserInteractionEnabled = false
        return button
    }
    
    private var tapHandler: ((SGGroundCell) -> Void)?
    
    // MARK: - UICollectionView hierarchy
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupGestureRecognizer()
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGestureRecognizer()
        self.setupSubviewsLayout()
    }
    
    // MARK: - Public functions
    
    enum Style {
        case separate
        case grouped
    }
    
    static func height(forGround ground: SGGround, width: CGFloat) -> CGFloat {
        let contentWidth = width - self.contentInsets.left - self.contentInsets.right
        
        let activitiesStackViewHeight: CGFloat = ground.activities.count > 0 ? 20.0 : 0
        
        let environmentsStackViewHeight: CGFloat = ground.environments.count > 0 ? 20.0 : 0
        
        return self.contentInsets.top
            + ground.address.capitalizingFirst.height(withConstrainedWidth: contentWidth,
                                                      font: .subtitle1Font)
            + 5
            + ground.district.capitalizingFirst.height(withConstrainedWidth: contentWidth,
                                                      font: .mediumTextFont)
            + 15
            + activitiesStackViewHeight
            + 8
            + environmentsStackViewHeight
            + self.contentInsets.bottom
    }
    
    func configure(withGround ground: SGGround, style: Style, tapHandler: @escaping (SGGroundCell) -> Void) {
        self.titleLabel.text = ground.address.capitalizingFirst
        self.subtitleLabel.text = ground.district.capitalizingFirst
        
        self.activitiesStackView.removeAllArrangedSubviews()
        ground.activities.forEach {
            let button = self.button(withIcon: $0.icon)
            self.activitiesStackView.addArrangedSubview(button)
        }
        
        self.environmentsStackView.removeAllArrangedSubviews()
        ground.environments.forEach {
            let button = self.button(withIcon: $0.icon)
            self.environmentsStackView.addArrangedSubview(button)
        }
        
        switch style {
        case .separate:
            self.backgroundColor = .appWhite
        case .grouped:
            self.backgroundColor = .appGray
        }
        
        self.tapHandler = tapHandler
    }
    
    // MARK: - Private functions
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentTouchUpInside(_:)))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupSubviewsLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        activitiesStackView.translatesAutoresizingMaskIntoConstraints = false
        environmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGGroundCell.contentInsets
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            subtitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            activitiesStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            activitiesStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            activitiesStackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            environmentsStackView.topAnchor.constraint(equalTo: activitiesStackView.bottomAnchor, constant: 8),
            environmentsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            environmentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            environmentsStackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -contentInsets.right)
        ])
    }
    
    @objc private func contentTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.tapHandler?(self)
    }
}
