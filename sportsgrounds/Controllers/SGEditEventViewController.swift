//
//  SGEditEventViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 04/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGEditEventViewController: SGStepViewController {
    
    let user: SGApplicationUser
    
    var eventId: Int?
    
    var processController: SGEditingEventProcess?
    var eventAPI: EventAPI?
    
    var onContinue: (() -> Void)?
    
    // MARK: - Private properties
    
    private var textField: SGTextField {
        let textField = SGTextField.textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }
    
    private lazy var nameTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Название"
        textField.text = self.processController?.title
        return textField
    }()
    
    private lazy var separatorView: SGSeparatorView = {
        let view = SGSeparatorView.view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
    }()
    
    private lazy var descriptionTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Описание"
        textField.text = self.processController?.description
        return textField
    }()
    
    // MARK: - UIViewController hierarchy
    
    init(user: SGApplicationUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Изменение события"
        self.subtitle = "Измените название или описание события даже после его создания"
        
        self.addBackButtonIfNeeded()
        self.setupArrangedViews()
        
        self.isButtonEnabled = self.processController?.isCompleted ?? false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredNavigationBarItemsConfigurationType: UINavigationController.ItemsConfigurationType {
        return .modal
    }
    
    // MARK: - Private functions
    
    private func setupArrangedViews() {
        self.arrangedSubviews = [self.nameTextField, self.separatorView, self.descriptionTextField]
    }
    
    // MARK: - SGViewController functions
    
    override func buttonTouchUpInside(_ sender: UIButton) {
        super.buttonTouchUpInside(sender)
        
        guard let eventId = self.eventId else {
            return
        }
        
        let loader = SGLoaderViewController()
        self.navigationController?.pushViewController(loader, animated: true)
        
        self.eventAPI?.updateEvent(withToken: self.user.token,
                                   eventId: eventId,
                                   title: self.processController?.title,
                                   description: self.processController?.description).done {
                                    [weak self] _ in
                                    
                                    performWithDelay {
                                        self?.onContinue?()
                                    }
        }.catch {
            [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension SGEditEventViewController: UITextFieldDelegate {
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == nameTextField {
            self.processController?.title = textField.text
        }
        
        if textField == descriptionTextField {
            self.processController?.description = textField.text
        }
        
        self.isButtonEnabled = self.processController?.isCompleted ?? false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}
