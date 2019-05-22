//
//  SGEventDescriptionCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEventDescriptionCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 16, left: 30, bottom: 8, right: 30)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .descriptionTextFont
        label.textColor = .appBlack
        label.textAlignment = .left
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
        return text.height(withConstrainedWidth: width - contentInsets.left - contentInsets.right,
                           font: .descriptionTextFont) + contentInsets.top + contentInsets.bottom
    }
    
    func configure(withText text: String) {
        self.label.text = text
        
        self.backgroundColor = .appGray
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGEventDescriptionCell.contentInsets
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right)
            ])
    }
}
