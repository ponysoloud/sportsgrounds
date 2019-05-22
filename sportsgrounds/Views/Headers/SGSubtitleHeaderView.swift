//
//  SGSubtitleHeaderView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGSubtitleHeaderView: UIView {
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 25, left: 20, bottom: 15, right: 20)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .subtitle1Font
        label.textColor = .appBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        
        self.addSubview(label)
        return label
    }()
    
    // MARK: - UIView hierarchy
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupSubviewsLayout()
    }
    
    // MARK: - Public functions
    
    static func height(forText text: String, width: CGFloat) -> CGFloat {
        return text.height(withConstrainedWidth: width - contentInsets.left - contentInsets.right,
                           font: .subtitle1Font) + contentInsets.top + contentInsets.bottom
    }
    
    func configure(withText text: String) {
        self.label.text = text
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGSubtitleHeaderView.contentInsets
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsets.left),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.bottom),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsets.right)
            ])
    }
}
