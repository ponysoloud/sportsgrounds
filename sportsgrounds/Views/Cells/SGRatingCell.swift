//
//  SGRatingCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 24/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGRatingCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        
        view.maskToBounds = false
        view.layer.cornerRadius = 12.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.2
        
        contentView.addSubview(view)
        return view
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        
        view.maskToBounds = true
        view.layer.cornerRadius = 12.0
        
        shadowView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .subtitle2Font
        label.textAlignment = .left
        label.numberOfLines = 0
        
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = .descriptionTextFont
        label.textAlignment = .left
        label.numberOfLines = 0
        
        cardView.addSubview(label)
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
    
    static func height(forRating rating: Int, width: CGFloat) -> CGFloat {
        var titleText: String
        var subtitleText: String
        
        if rating > 0 {
            if rating == 1 {
                titleText = "Вас отметил \(rating) человек"
            } else if rating < 5 {
                titleText = "Вас отметило \(rating) человека"
            } else {
                titleText = "Вас отметило \(rating) человек"
            }
            
            subtitleText = "Отмечайте и вы других, чтобы все знали с кем можно приятно позаниматься"
        } else {
            titleText = "Вас пока еще не отметили"
            subtitleText = "Присоединяйтесь к событиям, знакомьтесь с другими участниками, чтобы они отмечали вас"
        }
        
        let contentWidth = width - contentInsets.left - contentInsets.right - 14 - 14
        
        return contentInsets.top
            + 14
            + titleText.height(withConstrainedWidth: contentWidth,
                               font: .subtitle2Font)
            + 8
            + subtitleText.height(withConstrainedWidth: contentWidth,
                                  font: .descriptionTextFont)
            + 12
            + contentInsets.bottom
    }
    
    func configure(withRating rating: Int, width: CGFloat) {
        if rating > 0 {
            self.titleLabel.text = "Вас отметило \(rating) человек"
            self.subtitleLabel.text = "Отмечайте и вы других, чтобы все знали с кем можно приятно позаниматься"
        } else {
            self.titleLabel.text = "Вас пока еще не отметили"
            self.subtitleLabel.text = "Присоединяйтесь к событиям, знакомьтесь с другими участниками, чтобы они отмечали вас"
        }
        
        
        let contentWidth = width - SGRatingCell.contentInsets.left - SGRatingCell.contentInsets.right
        self.cardView.fill(withGradient: UIColor.blueGradient,
                           direction: .horizontal,
                           frame: CGRect(x: 0,
                                         y: 0,
                                         width: contentWidth,
                                         height: SGRatingCell.height(forRating: rating, width: width))
        )
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let cardInsets = SGRatingCell.contentInsets
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cardInsets.top),
            shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: cardInsets.left),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cardInsets.bottom),
            shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -cardInsets.right),
            
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            cardView.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            cardView.rightAnchor.constraint(equalTo: shadowView.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 14),
            titleLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -14),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 14),
            subtitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            subtitleLabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -14)
            ])
    }
}
