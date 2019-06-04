//
//  SGSmallProfileCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 01/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGSmallProfileCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var avatarImageView: SGAvatarImageView = {
        let imageView = SGAvatarImageView.imageView
        
        cardView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle3Font
        label.textAlignment = .left
        label.numberOfLines = 2
        
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle4Font
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var ratingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = .subtitle4Font
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "user.icon.rating.unfilled"), for: .normal)
        button.setImage(UIImage(named: "user.icon.rating.filled"), for: .selected)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.addTarget(self, action: #selector(ratingButtonTouchUpInside(_:)), for: .touchUpInside)
        
        cardView.addSubview(button)
        return button
    }()
    
    private var selectionRatingHandler: ((SGSmallProfileCell) -> Void)?
    private var unselectionRatingHandler: ((SGSmallProfileCell) -> Void)?
    
    // MARK: - UICollectionView hierarchy
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = UIImage(named: "user.avatar.placeholder")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviewsLayout()
    }
    
    // MARK: - Public functions
    
    static func height(forUser user: SGUser, width: CGFloat) -> CGFloat {
        let contentWidth = width - contentInsets.left - contentInsets.right - 75.0 - 89.0
        let nameText = "\(user.surname) \(user.name)"
        let ageText = user.birthdate.age.formattedAge
        
        return self.contentInsets.top
            + 20
            + nameText.height(withConstrainedWidth: contentWidth,
                              font: .subtitle3Font)
            + 4
            + ageText.height(withConstrainedWidth: contentWidth,
                             font: .subtitle4Font)
            + 20
            + self.contentInsets.bottom
    }
    
    func configure(withUser user: SGUser,
                   selectionRatingHandler: @escaping (SGSmallProfileCell) -> Void,
                   unselectionRatingHandler: @escaping (SGSmallProfileCell) -> Void) {
        
        if let avatarUrl = user.imageUrl {
            self.avatarImageView.load(url: avatarUrl, placeholder: nil)
        }
        
        self.nameLabel.text = "\(user.surname) \(user.name)"
        self.ageLabel.text = user.birthdate.age.formattedAge
        self.ratingButton.setTitle(user.rating.description, for: .normal)
        self.ratingButton.isSelected = user.rated
        
        self.selectionRatingHandler = selectionRatingHandler
        self.unselectionRatingHandler = unselectionRatingHandler
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingButton.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGSmallProfileCell.contentInsets
        
        nameLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        ratingButton.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        ratingButton.setContentCompressionResistancePriority(UILayoutPriority(1001), for: .horizontal)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            cardView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            cardView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right),
            
            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            avatarImageView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 20),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 49.0),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20.0),
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 20.0),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.0),
            ageLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 20.0),
            ageLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20.0),
            
            ratingButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            ratingButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 20.0),
            ratingButton.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -20.0)
            ])
    }
    
    @objc private func ratingButtonTouchUpInside(_ sender: UIButton) {
        if sender.isSelected {
            self.unselectionRatingHandler?(self)
        } else {
            self.selectionRatingHandler?(self)
        }
    }
}
