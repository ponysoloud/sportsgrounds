//
//  SGEventDetailsCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEventDetailsCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 6, left: 20, bottom: 16, right: 20)
    
    private lazy var activityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.date"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.time"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let levelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.muscle"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - UICollectionView hierarchy
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviewsLayout()
    }
    
    // MARK: - Public functions
    
    static var height: CGFloat {
        return 110.0
    }
    
    func configure(withEvent event: SGEvent) {
        self.activityLabel.text = SGEventPhrase(activity: event.activity, eventType: event.type).phrase
        
        self.buttonsStackView.removeAllArrangedSubviews()
        
        self.buttonsStackView.addArrangedSubview(dateButton)
        self.buttonsStackView.addArrangedSubview(timeButton)
        self.buttonsStackView.addArrangedSubview(levelButton)
        
        self.dateButton.setTitle(event.beginAt.recentFormatted, for: .normal)
        self.timeButton.setTitle("\(event.beginAt.time) - \(event.endAt.time)", for: .normal)
        self.levelButton.setTitle(event.requiredLevel.title, for: .normal)
        
        self.backgroundColor = .appGray
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGEventDetailsCell.contentInsets
        NSLayoutConstraint.activate([
            activityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            activityLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            activityLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            buttonsStackView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 8),
            buttonsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            buttonsStackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -contentInsets.right)
            ])
    }
    
    
}
