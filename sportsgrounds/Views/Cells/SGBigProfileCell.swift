//
//  SGBigProfileCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 24/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGBigProfileCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    
    private static let avatarImageViewSide: CGFloat = {
        return (UIScreen.main.bounds.width / 3.5 > 100) ? UIScreen.main.bounds.width / 3.5 : 100
    }()
    
    private lazy var avatarImageView: SGAvatarImageView = {
        let imageView = SGAvatarImageView.imageView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTouchUpInside(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle3Font
        label.textAlignment = .center
        label.numberOfLines = 2
        
        contentView.addSubview(label)
        return label
    }()
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle4Font
        label.textAlignment = .center
        label.numberOfLines = 1
        
        contentView.addSubview(label)
        return label
    }()
    
    private var tapHandler: ((SGBigProfileCell) -> Void)?
    
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
    
    static func height(forUser user: SGUser, width: CGFloat) -> CGFloat {
        let contentWidth = width - self.contentInsets.left - self.contentInsets.right
        let nameText = "\(user.surname) \(user.name)"
        let ageText = user.birthdate.age.formattedAge
        return self.contentInsets.top
            + self.avatarImageViewSide
            + 20
            + nameText.height(withConstrainedWidth: contentWidth,
                              font: .subtitle3Font)
            + 3
            + ageText.height(withConstrainedWidth: contentWidth,
                              font: .subtitle4Font)
            + self.contentInsets.bottom
    }
    
    func configure(withUser user: SGUser,
                   tapHandler: @escaping (SGBigProfileCell) -> Void) {
        
        if let avatarUrl = user.imageUrl {
            self.avatarImageView.load(url: avatarUrl, placeholder: #imageLiteral(resourceName: "user.avatar.placeholder"))
        }
        
        self.nameLabel.text = "\(user.surname) \(user.name)"
        self.ageLabel.text = user.birthdate.age.formattedAge
        
        self.tapHandler = tapHandler
    }
    
    func set(image: UIImage) {
        self.avatarImageView.image = image
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarSide = SGBigProfileCell.avatarImageViewSide
        
        let contentInsets = SGBigProfileCell.contentInsets
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            avatarImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSide),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right),
            
            ageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            ageLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            ageLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            ageLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right)
        ])
    }
    
    @objc private func imageTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.tapHandler?(self)
    }
}
