//
//  SGIncomeMessageCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGIncomeMessageCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 60)
    
    private lazy var cloudView: UIView = {
        let view = UIView()
        view.backgroundColor = .appLightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 24.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cloudTouchUpInside(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appSecondaryBlack
        label.font = .smallTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cloudView.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appSecondaryBlack
        label.font = .supersmallTextFont
        label.textAlignment = .right
        label.numberOfLines = 1
        
        cloudView.addSubview(label)
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .mediumTextFont
        label.textAlignment = .left
        label.numberOfLines = 0
        
        cloudView.addSubview(label)
        return label
    }()
    
    private var tapHandler: ((SGIncomeMessageCell) -> Void)?
    
    // MARK: - UICollectionView hierarchy
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviewsLayout()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let contentInsets = SGIncomeMessageCell.contentInsets
//        self.cloudView.layer.cornerRadius = (self.height - contentInsets.top - contentInsets.bottom) / 2
//    }
    
    // MARK: - Public functions
    
    static func height(forMessage message: SGMessage, width: CGFloat) -> CGFloat {
        let contentWidth = width - contentInsets.left - contentInsets.right - 30
        return contentInsets.top
            + 27
            + message.text.height(withConstrainedWidth: contentWidth, font: .mediumTextFont)
            + 23
            + contentInsets.bottom
    }
    
    func configure(withMessage message: SGMessage, tapHandler: @escaping (SGIncomeMessageCell) -> Void) {
        self.userLabel.text = "\(message.sender.surname) \(message.sender.name)"
        self.dateLabel.text = message.createdAt.timeRecentFormatted
        self.messageLabel.text = message.text
        self.tapHandler = tapHandler
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.setContentHuggingPriority(UILayoutPriority(250), for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        
        let contentInsets = SGIncomeMessageCell.contentInsets
        NSLayoutConstraint.activate([
            cloudView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            cloudView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            cloudView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            cloudView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -contentInsets.right),
            cloudView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100.0),
            
            userLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 10),
            userLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 15),
            userLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -10),
            
            dateLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -7),
            dateLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -15),
            
            messageLabel.topAnchor.constraint(equalTo: cloudView.topAnchor, constant: 27),
            messageLabel.leftAnchor.constraint(equalTo: cloudView.leftAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor, constant: -23),
            messageLabel.rightAnchor.constraint(equalTo: cloudView.rightAnchor, constant: -15)
            ])
    }
    
    @objc private func cloudTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.tapHandler?(self)
    }
}
