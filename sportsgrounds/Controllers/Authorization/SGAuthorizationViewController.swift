//
//  SGAuthorizationViewController.swift
//  courses-aggregator
//
//  Created by Alexander Ponomarev on 10/02/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide
import PromiseKit

class SGAuthorizationViewController: SGViewController {
    
    var authAPI: AuthAPI?
    var userAPI: UserAPI?
    
    var localDataManager: SGLocalDataManager?
    var processController: SGAuthorizationProcess?
    
    var onEnter: ((SGApplicationUser) -> Void)?
    var onRegistration: ((SGAuthorizationProcess) -> Void)?
    
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
    
    private lazy var emailTextField: SGTextField = {
        let textField = SGTextField.textField
        textField.placeholder = "Эл. адрес"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.text = self.processController?.email
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.delegate = self
        stackView.addArrangedSubview(textField)
        return textField
    }()
    
    private lazy var separatorView: SGSeparatorView = {
        let view = SGSeparatorView.view
        stackView.addArrangedSubview(view)
        return view
    }()
    
    private lazy var passwordTextField: SGTextField = {
        let textField = SGTextField.textField
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        textField.text = self.processController?.password
        
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
        
        if let localEmail = self.localDataManager?.getEmail() {
            self.processController?.email = localEmail
            self.emailTextField.text = localEmail
        }
        
        self.titleLabel.text = "Авторизация"
        self.subtitleLabel.text = "Введите эдрес электронной почты и пароль для входа"
        
        self.addConstraintsToSubviews()
        self.addBackButtonIfNeeded()
        self.addGestureRecognizerForHidingKeyboardOnTap()
        
        self.view.backgroundColor = UIColor.appWhite
        self.button.isEnabled = self.processController?.isAuthorizationComplete ?? false
    }
    
    // MARK: - Private Functions
    
    private func addConstraintsToSubviews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
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
            
            emailTextField.heightAnchor.constraint(equalToConstant: 50.0),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50.0),
            
            button.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 16.0),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let authAPI = self.authAPI,
            let userAPI = self.userAPI,
            let email = processController?.email,
            let password = processController?.password else {
            return
        }
        
        let loader = SGLoaderViewController()
        self.navigationController?.pushViewController(loader, animated: true)
        
        firstly {
            authAPI.login(email: email, password: password)
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
            
            let user = SGApplicationUser.save(withToken: token, user: user)
            performWithDelay {
                self?.onEnter?(user)
            }
        }.catch {
            [weak self]
            error in
            
            print(error)
            
            guard
                let serverError = error as? SportsgroundsResponseError,
                case let .serverFailureResponse(message: message) = serverError
                else {
                    
                    self?.errorLabel.text = "Какие-то проблемы с подключением"
                    
                    performWithDelay {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    return
            }
            
            switch message {
            case "User does not exist":
                if let processController = self?.processController {
                    performWithDelay {
                        self?.onRegistration?(processController)
                    }
                }
            case "Password is incorrect":
                self?.errorLabel.text = "Неправильный пароль"
                fallthrough
            default:
                performWithDelay {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension SGAuthorizationViewController: UITextFieldDelegate {
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == emailTextField {
            self.processController?.email = textField.text
        }
        
        if textField == passwordTextField {
            self.processController?.password = textField.text
        }
        
        self.button.isEnabled = self.processController?.isAuthorizationComplete ?? false
        
        self.errorLabel.text = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}
