//
//  SGTeamCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTeamCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 20, bottom: 5, right: 20)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30.0
        
        contentView.addSubview(stackView)
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle1Font
        label.textColor = .appBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let participantsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.participants"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
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
    
    static var height: CGFloat {
        return 35.0
    }
    
    func configure(withTeam team: SGTeam, index: Int? = nil) {
        self.stackView.removeAllArrangedSubviews()
        
        if let index = index {
            self.stackView.addArrangedSubview(self.titleLabel)
            self.titleLabel.text = "Команда \(index)"
        }
        
        self.stackView.addArrangedSubview(self.participantsButton)
        self.participantsButton.setTitle("\(team.participants.count)/\(team.maxParticipants)", for: .normal)
        
        self.backgroundColor = .appGray
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentInsets = SGTeamCell.contentInsets
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentInsets.top),
            stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: contentInsets.left),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -contentInsets.bottom),
            stackView.rightAnchor.constraint(lessThanOrEqualTo: self.contentView.rightAnchor, constant: -contentInsets.right)
        ])
    }
}
