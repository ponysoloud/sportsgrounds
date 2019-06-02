//
//  SGPlaceholderCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 02/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGPlaceholderCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 30, left: 35, bottom: 30, right: 35)
    
    private static let placeholderImageViewSide: CGFloat = {
        return UIScreen.main.bounds.width / 3.5
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        
        contentView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .subtitle1Font
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        
        contentView.addSubview(label)
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
    
    static func height(forText text: String, width: CGFloat) -> CGFloat {
        return contentInsets.top
        + placeholderImageViewSide
        + 15
        + text.height(withConstrainedWidth: width - contentInsets.left - contentInsets.right,
                      font: .subtitle1Font)
        + contentInsets.bottom
    }
    
    func configure(withText text: String, placeholder: UIImage) {
        self.label.text = text
        self.placeholderImageView.image = placeholder
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let placeholderSide = SGPlaceholderCell.placeholderImageViewSide
        let contentInsets = SGPlaceholderCell.contentInsets
        
        NSLayoutConstraint.activate([
            placeholderImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            placeholderImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            placeholderImageView.widthAnchor.constraint(equalTo: placeholderImageView.heightAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: placeholderSide),
            
            label.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 15),
            label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right)
            ])
    }
    
}
