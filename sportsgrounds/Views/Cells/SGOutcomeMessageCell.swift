//
//  SGOutcomeMessageCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGOutcomeMessageCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 5, left: 60, bottom: 5, right: 20)
    
    private lazy var cloudView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlue
        view.layer.masksToBounds = true
        
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhiteTransparent
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cloudView.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhiteTransparent
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cloudView.addSubview(label)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .mediumTextFont
        label.textAlignment = .left
        label.numberOfLines = 0
        
        cloudView.addSubview(label)
        return label
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentInsets = SGOutcomeMessageCell.contentInsets
        self.cloudView.layer.cornerRadius = (self.height - contentInsets.top - contentInsets.bottom) / 2
    }
    
    // MARK: - Public functions
    
    static func height(forMessage message: SGMessage, width: CGFloat) -> CGFloat {
        let contentWidth = width - contentInsets.left - contentInsets.right
        return contentInsets.top
            + 15
            + "\(message.sender.surname) \(message.sender.name)".height(withConstrainedWidth: contentWidth, font: .smallTextFont)
            + 3
            + message.text.height(withConstrainedWidth: contentWidth, font: .mediumTextFont)
            + 15
            + contentInsets.bottom
    }
    
    func configure(withMessage message: SGMessage) {
        self.userLabel.text = "\(message.sender.surname) \(message.sender.name)"
        self.dateLabel.text = message.createdAt.timeRecentFormatted
        self.messageLabel.text = message.text
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        
        let contentInsets = SGOutcomeMessageCell.contentInsets
        NSLayoutConstraint.activate([
            cloudView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            cloudView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            cloudView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            cloudView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            userLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 15),
            userLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 28),
            
            dateLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 15),
            dateLabel.leftAnchor.constraint(equalTo: userLabel.rightAnchor, constant: 10),
            dateLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -28),
            
            messageLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 3),
            messageLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 28),
            messageLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -15),
            messageLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -28)
            ])
    }
}
