//
//  SGBorderedButtonCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGBorderedButtonCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 20, left: 60, bottom: 20, right: 60)
    
    private lazy var button: SGButton = {
        let button = SGButton(type: .custom)
        button.setBackgroundImage(UIImage.image(withColor: UIColor.appWhite), for: .normal)
        button.setBackgroundImage(UIImage.image(withColor: UIColor.appBlack.withAlphaComponent(0.05)), for: .highlighted)
        
        button.borderWidth = 1
        button.borderColor = .appBlack
        
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        
        button.titleLabel?.font = UIFont.subtitle1Font
        button.setTitleColor(UIColor.appBlack, for: .normal)
        
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        contentView.addSubview(button)
        return button
    }()
    
    private var tapHandler: ((SGBorderedButtonCell) -> Void)?
    
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
    
    static var height: CGFloat {
        return 80.0
    }
    
    func configure(withTitle title: String, tapHandler: @escaping (SGBorderedButtonCell) -> Void) {
        self.button.setTitle(title, for: .normal)
        self.tapHandler = tapHandler
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        button.translatesAutoresizingMaskIntoConstraints = false

        let contentInsets = SGBorderedButtonCell.contentInsets
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            button.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            button.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -contentInsets.right)
        ])
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        self.tapHandler?(self)
    }
}
