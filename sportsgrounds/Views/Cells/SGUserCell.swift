//
//  SGUserCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGUserCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    private lazy var avatarImageView: SGAvatarImageView = {
        let imageView = SGAvatarImageView.imageView
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var ratingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "user.icon.rating.small"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        
        contentView.addSubview(button)
        return button
    }()
    
    private lazy var hostImageView: UIImageView = {
        let button = UIImageView(image: UIImage(named: "user.icon.host"))
        button.contentMode = .scaleAspectFit
        contentView.addSubview(button)
        return button
    }()
    
    private var tapHandler: ((SGUserCell) -> Void)?
    
    // MARK: - UICollectionView hierarchy
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviewsLayout()
        self.setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviewsLayout()
        self.setupGestureRecognizer()
    }
    
    // MARK: - Public functions
    
    enum Style {
        case separate
        case grouped
    }
    
    static var height: CGFloat {
        return 55.0
    }
    
    func configure(withUser user: SGUser,
                   isOwner: Bool,
                   isYou: Bool,
                   style: Style,
                   tapHandler: @escaping (SGUserCell) -> Void) {
        
        if let avatarUrl = user.imageUrl {
            self.avatarImageView.load(url: avatarUrl, placeholder: #imageLiteral(resourceName: "user.avatar.placeholder"))
        }
        
        self.hostImageView.isHidden = !isOwner
        self.nameLabel.textColor = isYou ? .appBlue : .appBlack
        
        self.nameLabel.text = "\(user.surname) \(user.name)"
        self.ageLabel.text = "\(user.birthdate.age) лет"
        
        self.ratingButton.isHidden = !(user.rating > 0)
        self.ratingButton.setTitle(user.rating.description, for: .normal)
        
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
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        hostImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingButton.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGUserCell.contentInsets
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 16),
            
            hostImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            hostImageView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10.0),
            hostImageView.heightAnchor.constraint(equalTo: hostImageView.widthAnchor),
            hostImageView.widthAnchor.constraint(equalToConstant: 10.0),
            hostImageView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -contentInsets.right),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            ageLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 16),
            ageLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            
            ratingButton.leftAnchor.constraint(equalTo: ageLabel.rightAnchor, constant: 20),
            ratingButton.centerYAnchor.constraint(equalTo: ageLabel.centerYAnchor)
            ])
    }
    
    @objc private func contentTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.tapHandler?(self)
    }
}
