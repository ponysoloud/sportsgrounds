//
//  SGTextView.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 21/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGTextView: UITextView {
    
    static var textView: SGTextView {
        let textView = SGTextView()
        textView.regularTextColor = UIColor.appBlack
        textView.placeholderTextColor = UIColor.appBlack.withAlphaComponent(0.6)
        textView.font = UIFont.mediumTextFont
        
        textView.backgroundColor = UIColor.appLightBlack
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.masksToBounds = true
        
        textView.delegate = textView
        
        return textView
    }
    
    // MARK: - Public properties
    
    var regularText: String? {
        get {
            if self.isPlaceholder {
                return nil
            } else {
                return self.text
            }
        }
        
        set {
            if regularText != nil, !(regularText ?? "").isEmpty {
                self.text = regularText
                self.textColor = regularTextColor
                self.isPlaceholder = false
            } else {
                self.text = placeholder
                self.textColor = placeholderTextColor
                self.isPlaceholder = true
            }
        }
    }
    
    var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    var regularTextColor: UIColor?
    var placeholderTextColor: UIColor?
    
    private(set) var isPlaceholder: Bool = false
    
    // MARK: - UITextView Hierarchy
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.height / 2
    }
    
    // MARK: - Private functions
    
    private func updatePlaceholder() {
        if self.text.isEmpty, !self.isPlaceholder {
            self.text = placeholder
            self.textColor = placeholderTextColor
            self.isPlaceholder = true
        }
    }
}

extension SGTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.isPlaceholder {
            self.text = nil
            self.textColor = regularTextColor
            self.isPlaceholder = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholder()
    }
}
