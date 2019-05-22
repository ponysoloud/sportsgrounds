//
//  SGEventCell.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEventCell: UITableViewCell {
    
    // MARK: - Public properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Private properties
    
    private static let contentInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    
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
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        
        view.maskToBounds = true
        view.layer.cornerRadius = 12.0
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cardTouchUpInside(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0.0
        view.addGestureRecognizer(longPressGestureRecognizer)
        
        shadowView.addSubview(view)
        return view
    }()
    
    private lazy var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        cardView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .subtitle2Font
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .descriptionTextFont
        label.textAlignment = .left
        label.numberOfLines = 1
        
        cardView.addSubview(label)
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15.0
        
        cardView.addSubview(stackView)
        return stackView
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.date"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let timeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.time"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let levelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.smallTextFont
        button.setTitleColor(.appBlack, for: .normal)
        button.setImage(UIImage(named: "event.icon.muscle"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private var tapHandler: ((SGEventCell) -> Void)?
    
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
    
    static func height(forEventInfo eventInfo: SGEventInfo) -> CGFloat {
        switch eventInfo.status {
        case .processing, .scheduled:
            return 102.0
        case .ended, .canceled:
            return 86.0
        }
    }
    
    func configure(withEventInfo eventInfo: SGEventInfo, tapHandler: @escaping (SGEventCell) -> Void) {
        self.titleLabel.text = eventInfo.title
        self.subtitleLabel.text = SGEventPhrase(activity: eventInfo.activity, eventType: eventInfo.type).phrase
        self.tapHandler = tapHandler
        
        switch eventInfo.status {
        case .processing:
            self.timeButton.removeFromSuperview()
            self.timeButton.setTitle("До \(eventInfo.beginAt.time)", for: .normal)
            self.buttonsStackView.addArrangedSubview(timeButton)
    
            self.detailView.fill(withGradient: UIColor.greenGradient,
                                 direction: .diagonal,
                                 frame: CGRect(x: 0,
                                               y: 0,
                                               width: 14,
                                               height: SGEventCell.height(forEventInfo: eventInfo)
                                                - SGEventCell.contentInsets.top
                                                - SGEventCell.contentInsets.bottom))
        case .scheduled:
            self.dateButton.removeFromSuperview()
            self.dateButton.setTitle(eventInfo.beginAt.recentFormatted, for: .normal)
            self.buttonsStackView.addArrangedSubview(dateButton)
            
            self.timeButton.removeFromSuperview()
            self.timeButton.setTitle("\(eventInfo.beginAt.time) - \(eventInfo.endAt.time)", for: .normal)
            self.buttonsStackView.addArrangedSubview(timeButton)
            
            self.levelButton.removeFromSuperview()
            self.levelButton.setTitle(eventInfo.requiredLevel.title, for: .normal)
            self.buttonsStackView.addArrangedSubview(levelButton)
            
            self.detailView.fill(withGradient: UIColor.blueGradient,
                                 direction: .diagonal,
                                 frame: CGRect(x: 0,
                                               y: 0,
                                               width: 14,
                                               height: SGEventCell.height(forEventInfo: eventInfo)
                                                - SGEventCell.contentInsets.top
                                                - SGEventCell.contentInsets.bottom))
        case .ended, .canceled:
            self.dateButton.removeFromSuperview()
            self.timeButton.removeFromSuperview()
            self.levelButton.removeFromSuperview()
            
            self.detailView.layer.sublayers?.removeAll()
        }
    }
    
    // MARK: - Private functions
    
    private func setupSubviewsLayout() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        cardView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        buttonsStackView.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        
        let cardInsets = SGEventCell.contentInsets
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cardInsets.top),
            shadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: cardInsets.left),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cardInsets.bottom),
            shadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -cardInsets.right),
            
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            cardView.leftAnchor.constraint(equalTo: shadowView.leftAnchor),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            cardView.rightAnchor.constraint(equalTo: shadowView.rightAnchor),
            
            detailView.topAnchor.constraint(equalTo: cardView.topAnchor),
            detailView.widthAnchor.constraint(equalToConstant: 14),
            detailView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            detailView.rightAnchor.constraint(equalTo: cardView.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 14),
            titleLabel.rightAnchor.constraint(equalTo: detailView.leftAnchor, constant: -10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 14),
            subtitleLabel.rightAnchor.constraint(equalTo: detailView.leftAnchor, constant: -10),
            
            buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            buttonsStackView.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 14),
            buttonsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            buttonsStackView.rightAnchor.constraint(lessThanOrEqualTo: detailView.leftAnchor, constant: -10)
        ])
    }
    
    @objc private func cardTouchUpInside(_ sender: UITapGestureRecognizer) {
        self.cardView.isUserInteractionEnabled = false
        
        self.cardView.simulateScalingOnTap(usingGestureRecognizer: sender,
                                           withEvent: {
                                            [unowned self] in
                                            self.tapHandler?(self)
                                            self.cardView.isUserInteractionEnabled = true
        },
                                           completion: {
                                            [unowned self] in
                                            self.cardView.isUserInteractionEnabled = true
        })
    }
}
