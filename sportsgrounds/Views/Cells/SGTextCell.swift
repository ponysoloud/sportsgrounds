//
//  SGTextCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTextCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 15, left: 20, bottom: 10, right: 20)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .smallTextFont
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
        return text.height(withConstrainedWidth: width - contentInsets.left - contentInsets.right,
                           font: .smallTextFont) + contentInsets.top + contentInsets.bottom
    }
    
    func configure(withText text: String) {
        self.label.text = text
        self.backgroundColor = .appGray
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGTextCell.contentInsets
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right)
            ])
    }
}
