//
//  SGMapCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 23/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGMapCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 15, bottom: 20, right: 15)
    
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
    
    private lazy var mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.maskToBounds = true
        imageView.layer.cornerRadius = 12.0
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapTouchUpInside(_:)))
        longPressGestureRecognizer.cancelsTouchesInView = false
        longPressGestureRecognizer.minimumPressDuration = 0.05
        imageView.addGestureRecognizer(longPressGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        
        shadowView.addSubview(imageView)
        return imageView
    }()
    
    private var tapHandler: ((SGMapCell) -> Void)?
    
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
        return 90.0 + SGMapCell.contentInsets.top + SGMapCell.contentInsets.bottom
    }
    
    static func mapSize(forWidth width: CGFloat) -> CGSize {
        let contentInsets = SGMapCell.contentInsets
        return CGSize(width: width - contentInsets.left - contentInsets.right,
                      height: self.height - contentInsets.top - contentInsets.bottom)
    }
    
    func configure(withSnapshotUrl snapshotUrl: URL, style: Style, tapHandler: @escaping (SGMapCell) -> Void) {
        self.mapImageView.load(url: snapshotUrl, placeholder: nil)
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
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        mapImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGMapCell.contentInsets
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentInsets.top),
            shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: contentInsets.left),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentInsets.bottom),
            shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -contentInsets.right),
            
            mapImageView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            mapImageView.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
            mapImageView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            mapImageView.rightAnchor.constraint(equalTo: shadowView.rightAnchor)
            ])
    }
    
    @objc private func mapTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.mapImageView.isUserInteractionEnabled = false
        
        self.mapImageView.simulateScalingOnTap(usingGestureRecognizer: sender,
                                               withEvent: {
                                                [unowned self] in
                                                self.tapHandler?(self)
                                                self.mapImageView.isUserInteractionEnabled = true
                                                
            },
                                               completion: {
                                                [weak self] in
                                                self?.mapImageView.isUserInteractionEnabled = true
            })
    }
}
