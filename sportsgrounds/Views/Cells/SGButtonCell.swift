//
//  SGButtonCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGButtonCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    
    private lazy var button: SGButton = {
        let button = SGButton.button
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        contentView.addSubview(button)
        return button
    }()
    
    private var tapHandler: ((SGButtonCell) -> Void)?
    
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
    
    enum Style {
        case separate
        case grouped
    }
    
    static var height: CGFloat {
        return 70.0
    }
    
    func configure(withTitle title: String, style: Style, tapHandler: @escaping (SGButtonCell) -> Void) {
        self.button.setTitle(title, for: .normal)
        self.tapHandler = tapHandler
        
        switch style {
        case .separate:
            self.backgroundColor = .appWhite
        case .grouped:
            self.backgroundColor = .appGray
        }
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGButtonCell.contentInsets
        
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
