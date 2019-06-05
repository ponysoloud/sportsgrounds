//
//  SGRegistrationViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 09/02/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide
import PromiseKit

class SGRegistrationViewController: SGViewController {
    
    var authAPI: AuthAPI?
    var userAPI: UserAPI?
    
    var localDataManager: SGLocalDataManager?
    var processController: SGAuthorizationProcess?
    
    var onEnter: ((SGApplicationUser) -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.titleFont
        
        view.addSubview(label)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.appBlack
        label.font = UIFont.largeTextFont
        
        view.addSubview(label)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 4.0
        
        view.addSubview(stackView)
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "courseInfo.image.placeholder")
        
        view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var nameTextField: SGTextField = {
        let textField = SGTextField.textField
        textField.placeholder = "Имя"
        textField.keyboardType = .namePhonePad
        textField.text = self.processController?.name
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        return textField
    }()
    
    private lazy var separator1View: SGSeparatorView = {
        let view = SGSeparatorView.view
        stackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var surnameTextField: SGTextField = {
        let textField = SGTextField.textField
        textField.placeholder = "Фамилия"
        textField.keyboardType = .namePhonePad
        textField.text = self.processController?.surname
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        return textField
    }()
    
    private lazy var separator2View: SGSeparatorView = {
        let view = SGSeparatorView.view
        stackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var birthdateTextField: SGTextField = {
        let textField = SGTextField.textField
        textField.placeholder = "Дата рождения"
        textField.text = self.processController?.birthdate?.longFormatted
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        return textField
    }()
    
    private lazy var errorLabel: SGErrorLabel = {
        let label = SGErrorLabel.label
        label.textInsets = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 0)
        
        stackView.addArrangedSubview(label)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = SGButton.button
        button.setTitle("Продолжить", for: .normal)
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "Регистрация"
        self.subtitleLabel.text = "Возможно вы новенький, поэтому введите пожалуйста дополнительные данные"
        
        self.addConstraintsToSubviews()
        self.addBackButtonIfNeeded()
        self.addGestureRecognizerForHidingKeyboardOnTap()
        
        self.view.backgroundColor = UIColor.appWhite
        self.button.isEnabled = self.processController?.isRegistrationComplete ?? false
    }
    
    // MARK: - Private Functions
    
    private func addConstraintsToSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        separator1View.translatesAutoresizingMaskIntoConstraints = false
        surnameTextField.translatesAutoresizingMaskIntoConstraints = false
        separator2View.translatesAutoresizingMaskIntoConstraints = false
        birthdateTextField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        subtitleLabel.setContentHuggingPriority(UILayoutPriority(200), for: .vertical)
        
        errorLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27.0)
        topConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            topConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36.0),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36.0),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15.0),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36.0),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36.0),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 27.0),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50.0),
            separator1View.heightAnchor.constraint(equalToConstant: 1.0),
            surnameTextField.heightAnchor.constraint(equalToConstant: 50.0),
            separator2View.heightAnchor.constraint(equalToConstant: 1.0),
            birthdateTextField.heightAnchor.constraint(equalToConstant: 50.0),
            
            button.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 16.0),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        self.dismissKeyboard()
        
        guard let authAPI = self.authAPI,
            let userAPI = self.userAPI,
            let email = processController?.email,
            let password = processController?.password,
            let name = processController?.name,
            let surname = processController?.surname,
            let birthdate = processController?.birthdate else {
                return
        }
        
        let loader = SGLoaderViewController()
        self.navigationController?.pushViewController(loader, animated: true)
        
        firstly {
            authAPI.register(email: email, password: password, name: name, surname: surname, birthdate: birthdate)
        }.then {
            [weak self]
            (token: String) -> Promise<(String, SGUser)> in
            
            self?.localDataManager?.removeToken()
            self?.localDataManager?.save(email: email)
            self?.localDataManager?.save(token: token)
            
            return userAPI.getUser(withToken: token).map { (token, $0) }
        }.done {
            [weak self]
            token, user in
            
            let user = SGApplicationUser(token: token, user: user)
            performWithDelay {
                self?.onEnter?(user)
            }
        }.catch {
            [weak self]
            error in
            
            self?.errorLabel.text = "Какие-то проблемы с подключением"
            
            performWithDelay {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SGRegistrationViewController: UITextFieldDelegate {
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == nameTextField {
            self.processController?.name = textField.text
        }
        
        if textField == surnameTextField {
            self.processController?.surname = textField.text
        }
        
        self.button.isEnabled = self.processController?.isRegistrationComplete ?? false
        self.errorLabel.text = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == birthdateTextField {
            self.dismissKeyboard()
            
            let alert = UIAlertController(style: .actionSheet, title: "Выберите дату рождения")
            
            alert.addDatePicker(mode: .date, date: processController?.birthdate, minimumDate: nil, maximumDate: Date()) {
                date in
                
                textField.text = date.longFormatted
                self.processController?.birthdate = date
                self.button.isEnabled = self.processController?.isRegistrationComplete ?? false
                
                self.errorLabel.text = nil
            }
            
            alert.addAction(title: "Готово", style: .cancel)
            alert.show()
            
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}
