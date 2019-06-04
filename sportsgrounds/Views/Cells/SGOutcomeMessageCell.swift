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
        view.layer.cornerRadius = 24.0
        
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhiteTransparent
        label.font = .supersmallTextFont
        label.textAlignment = .right
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
    
    // MARK: - Public functions
    
    static func height(forMessage message: SGMessage, width: CGFloat) -> CGFloat {
        let contentWidth = width - contentInsets.left - contentInsets.right - 30
        return contentInsets.top
            + 10
            + message.text.height(withConstrainedWidth: contentWidth, font: .mediumTextFont)
            + 23
            + contentInsets.bottom
    }
    
    func configure(withMessage message: SGMessage) {
        self.dateLabel.text = message.createdAt.timeRecentFormatted
        self.messageLabel.text = message.text
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGOutcomeMessageCell.contentInsets
        NSLayoutConstraint.activate([
            cloudView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            cloudView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: contentInsets.left),
            cloudView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            cloudView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            cloudView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            dateLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -7),
            dateLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -15),
            
            messageLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 10),
            messageLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -23),
            messageLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -15)
            ])
    }
}
