//
//  SGTitleButtonHeaderView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTitleButtonHeaderView: UIView {
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .title3Font
        label.textColor = .appBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        
        addSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "event.icon.add"), for: .normal)
        button.setImage(UIImage(named: "event.icon.add.highlighted"), for: .highlighted)
        
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        addSubview(button)
        return button
    }()
    
    private var tapHandler: ((SGTitleButtonHeaderView) -> Void)?
    
    // MARK: - UIView hierarchy
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .appWhite
        self.setupSubviewsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .appWhite
        self.setupSubviewsLayout()
    }
    
    // MARK: - Public functions
    
    static func height(forText text: String, width: CGFloat) -> CGFloat {
        return text.height(withConstrainedWidth: width - contentInsets.left - contentInsets.right - 35.0,
                           font: .title3Font) + contentInsets.top + contentInsets.bottom
    }
    
    func configure(withText text: String, tapHandler: @escaping (SGTitleButtonHeaderView) -> Void) {
        self.label.text = text
        self.tapHandler = tapHandler
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGTitleButtonHeaderView.contentInsets
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInsets.top),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInsets.left),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInsets.bottom),
            label.rightAnchor.constraint(equalTo: self.button.leftAnchor, constant: -15),
            
            button.centerYAnchor.constraint(equalTo: self.label.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20.0),
            button.heightAnchor.constraint(equalTo: self.button.widthAnchor),
            button.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -contentInsets.right),
        ])
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        self.tapHandler?(self)
    }
}
