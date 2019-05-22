//
//  SGSeparatorCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGSeparatorCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    private lazy var separatorView: SGSeparatorView = {
        let view = SGSeparatorView.view
        
        contentView.addSubview(view)
        return view
    }()
    
    // MARK: - Public functions
    
    enum Style {
        case separate
        case grouped
    }
    
    static var height: CGFloat {
        return 1.0
    }
    
    func configure(withStyle style: Style) {
        switch style {
        case .separate:
            self.backgroundColor = .appWhite
        case .grouped:
            self.backgroundColor = .appGray
        }
    }
    
    // MARK: - Private functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentInsets = SGSeparatorCell.contentInsets
        self.separatorView.frame = CGRect(x: contentInsets.left,
                                          y: contentInsets.top,
                                          width: self.width - contentInsets.left - contentInsets.right,
                                          height: self.height - contentInsets.top - contentInsets.bottom)
    }
}
