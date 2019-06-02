//
//  SGCreateEventViewController.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGCreateEventViewController: SGStepViewController {
    
    let user: SGApplicationUser
    let step: SGCreatingEventStep
    
    var processController: SGCreatingEventProcess?
    var eventAPI: EventAPI?
    
    var onCreate: (() -> Void)?
    var onContinue: ((SGCreatingEventProcess) -> Void)?
    
    // MARK: - Private properties
    
    private var textField: SGTextField {
        let textField = SGTextField.textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.delegate = self
        return textField
    }
    
    private var separatorView: SGSeparatorView {
        let view = SGSeparatorView.view
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        return view
    }
    
    private lazy var nameTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Название"
        textField.text = self.processController?.title
        return textField
    }()
    
    private lazy var descriptionTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Описание"
        textField.text = self.processController?.description
        return textField
    }()
    
    private lazy var activityTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Вид спорта"
        textField.text = self.processController?.activity?.title
        return textField
    }()
    
    private lazy var typeTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Тип события"
        textField.text = self.processController?.type?.title
        return textField
    }()
    
    private lazy var participantsCountTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Количество участников"
        textField.text = self.processController?.participantsCount?.description
        return textField
    }()
    
    private lazy var teamsCountTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Количество команд"
        textField.text = self.processController?.teamsCount?.description
        return textField
    }()
    
    private lazy var participantsLevelTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Уровень участников"
        textField.text = self.processController?.participantsLevel?.title
        return textField
    }()
    
    private lazy var participantsAgeTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Допустимый возраст"
        if let ageFrom = self.processController?.participantsAgeFrom,
            let ageTo = self.processController?.participantsAgeFrom {
            textField.text = "\(ageFrom.description) - \(ageTo.description)"
        }
        return textField
    }()
    
    private lazy var dateTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Время и дата проведения"
        textField.text = self.processController?.date?.fullFormatted
        return textField
    }()
    
    private lazy var durationTextField: SGTextField = {
        let textField = self.textField
        textField.placeholder = "Продолжительность"
        if let durationString = self.processController?.duration?.description {
            textField.text = "\(durationString) минут"
        }
        return textField
    }()
    
    private lazy var errorLabel: SGErrorLabel = {
        let label = SGErrorLabel.label
        label.textInsets = UIEdgeInsets(top: 0, left: 18.0, bottom: 0, right: 0)
        return label
    }()
    
    // MARK: - UIViewController hierarchy
    
    init(user: SGApplicationUser, step: SGCreatingEventStep) {
        self.user = user
        self.step = step
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = step.title
        self.subtitle = step.subtitle
        
        self.addBackButtonIfNeeded()
        self.setupArrangedViews()
        
        self.isButtonEnabled = self.processController?.isCompleted(step: step) ?? false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredNavigationBarItemsConfigurationType: UINavigationController.ItemsConfigurationType {
        return .modal
    }
    
    // MARK: - Public functions
    
    func createEvent() {
        guard
            let process = self.processController,
            let type = process.type,
            let title = process.title,
            let description = process.description,
            let activity = process.activity,
            let participantsLevel = process.participantsLevel,
            let participantsAgeFrom = process.participantsAgeFrom,
            let participantsAgeTo = process.participantsAgeTo,
            let date = process.date,
            let duration = process.duration else {
                fatalError()
        }
        
        let loader = SGLoaderViewController()
        self.navigationController?.pushViewController(loader, animated: true)
        
        eventAPI?.createEvent(withToken: user.token,
                              groundId: process.ground.id,
                              type: type,
                              title: title,
                              description: description,
                              activity: activity,
                              participantsLevel: participantsLevel,
                              participantsAgeFrom: participantsAgeFrom,
                              participantsAgeTo: participantsAgeTo,
                              beginAt: date,
                              endAt: date.adding(minutes: duration),
                              participantsCount: process.participantsCount,
                              teamsCount: process.teamsCount,
                              teamsSize: process.teamsCount != nil ? process.participantsCount : nil).done {
                                [weak self] _ in
                                
                                performWithDelay {
                                    self?.onCreate?()
                                }
        }.catch {
            error in
            print(error)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private functions
    
    private func setupArrangedViews() {
        switch step {
        case .general:
            self.arrangedSubviews = [self.nameTextField, self.separatorView, self.descriptionTextField]
        case .activityDetails:
            self.arrangedSubviews = [self.activityTextField, self.separatorView, self.typeTextField]
        case .participantsDetails:
            self.arrangedSubviews = [self.participantsLevelTextField, self.separatorView, self.participantsAgeTextField]
        case .dateDetails:
            self.arrangedSubviews = [self.dateTextField, self.separatorView, self.durationTextField]
        }
    }
    
    private func updateArrangedVeiws(withActivity activity: SGActivity) {
        self.processController?.type = nil
        self.typeTextField.text = nil
        
        if let _ = self.teamsCountTextField.superview {
            self.processController?.teamsCount = nil
            self.teamsCountTextField.text = nil
            
            self.teamsCountTextField.removeFromSuperview()
            self.arrangedSubviews.last?.removeFromSuperview()
        }
        
        if let _ = self.participantsCountTextField.superview {
            self.processController?.participantsCount = nil
            self.participantsCountTextField.text = nil
            
            self.participantsCountTextField.removeFromSuperview()
            self.arrangedSubviews.last?.removeFromSuperview()
        }
    }
    
    private func updateArrangedVeiws(withEventType eventType: SGEventType) {
        switch eventType {
        case .training:
            if let _ = self.teamsCountTextField.superview {
                self.processController?.teamsCount = nil
                self.teamsCountTextField.text = nil
                
                self.teamsCountTextField.removeFromSuperview()
                self.arrangedSubviews.last?.removeFromSuperview()
            }
            
            if let _ = self.participantsCountTextField.superview {
                self.processController?.participantsCount = nil
                self.participantsCountTextField.text = nil
            } else {
                self.addArrangedSubview(self.separatorView)
                self.addArrangedSubview(self.participantsCountTextField)
            }
            
            self.participantsCountTextField.placeholder = "Количество участников"
        case .match:
            if let _ = self.teamsCountTextField.superview {
                self.processController?.teamsCount = nil
                self.teamsCountTextField.text = nil
                
                self.teamsCountTextField.removeFromSuperview()
                self.arrangedSubviews.last?.removeFromSuperview()
            }
            
            if let _ = self.participantsCountTextField.superview {
                self.processController?.participantsCount = nil
                self.participantsCountTextField.text = nil
            } else {
                self.addArrangedSubview(self.separatorView)
                self.addArrangedSubview(self.participantsCountTextField)
            }
            
            self.participantsCountTextField.placeholder = "Количество участников в команде"
        case .tourney:
            if let _ = self.participantsCountTextField.superview {
                self.processController?.participantsCount = nil
                self.participantsCountTextField.text = nil
            } else {
                self.addArrangedSubview(self.separatorView)
                self.addArrangedSubview(self.participantsCountTextField)
            }
            
            self.participantsCountTextField.placeholder = "Количество участников в команде"
            
            if let _ = self.teamsCountTextField.superview {
                self.processController?.teamsCount = nil
                self.teamsCountTextField.text = nil
            } else {
                self.addArrangedSubview(self.separatorView)
                self.addArrangedSubview(self.teamsCountTextField)
            }
        }
    }
    
    // MARK: - SGViewController functions
    
    override func buttonTouchUpInside(_ sender: UIButton) {
        super.buttonTouchUpInside(sender)
        
        guard let process = self.processController else {
            return
        }
        
        self.onContinue?(process)
    }
}

extension SGCreateEventViewController: UITextFieldDelegate {
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if step == .general {
            if textField == nameTextField {
                self.processController?.title = textField.text
            }
            
            if textField == descriptionTextField {
                self.processController?.description = textField.text
            }
        }
        self.isButtonEnabled = self.processController?.isCompleted(step: step) ?? false
        self.errorLabel.text = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch step {
        case .general:
            return true
        case .activityDetails:
            if textField == self.activityTextField, let ground = self.processController?.ground {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите вид спорта")
                
                for activity in ground.activities {
                    alert.addAction(title: activity.title, style: .default) { _ in
                        self.updateArrangedVeiws(withActivity: activity)
                        
                        self.activityTextField.text = activity.title
                        self.processController?.activity = activity
                        
                        self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                        self.errorLabel.text = nil
                    }
                }
                
                alert.addAction(title: "Отменить", style: .cancel)
                alert.show()
                
                return false
            }
            
            if textField == self.typeTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите тип события")
                
                if let activity = self.processController?.activity {
                    for type in activity.accessibleEventTypes {
                        alert.addAction(title: type.title, style: .default) { _ in
                            self.updateArrangedVeiws(withEventType: type)
                            
                            self.typeTextField.text = type.title
                            self.processController?.type = type
                            
                            self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                            self.errorLabel.text = nil
                        }
                    }
                } else {
                    alert.addEnumerationPicker(SGEventType.self) { type in
                        self.updateArrangedVeiws(withEventType: type)
                        
                        self.typeTextField.text = type.title
                        self.processController?.type = type
                        
                        self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                        self.errorLabel.text = nil
                    }
                }

                alert.addAction(title: "Отменить", style: .cancel)
                alert.show()
                
                return false
            }
            
            if textField == self.participantsCountTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите количество участников")
                
                let participantsCounts: [[String]] = [(2...15).map { Int($0).description }]
                alert.addPickerView(values: participantsCounts) { (vc, picker, index, values) in
                    self.participantsCountTextField.text = values[index.column][index.row]
                    self.processController?.participantsCount = Int(values[index.column][index.row])
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                }
                
                alert.addAction(title: "Готово", style: .cancel)
                alert.show()
                
                return false
            }
            
            if textField == self.teamsCountTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите количество команд")
                
                let participantsCounts: [[String]] = [(3...8).map { Int($0).description }]
                alert.addPickerView(values: participantsCounts) { (vc, picker, index, values) in
                    self.teamsCountTextField.text = values[index.column][index.row]
                    self.processController?.teamsCount = Int(values[index.column][index.row])
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                }
                
                alert.addAction(title: "Готово", style: .cancel)
                alert.show()
                
                return false
            }
        case .participantsDetails:
            if textField == self.participantsLevelTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите уровень участников")
                alert.addEnumerationPicker(SGParticipantsLevel.self) { level in
                    self.participantsLevelTextField.text = level.title
                    self.processController?.participantsLevel = level
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                }
                
                alert.addAction(title: "Отменить", style: .cancel)
                alert.show()
                
                return false
            }
            
            if textField == self.participantsAgeTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Укажите возрастнные ограничения")
                
                alert.addRangePicker(lowerValue: self.processController?.participantsAgeFrom,
                                     upperValue: self.processController?.participantsAgeTo,
                                     minimumValue: 3,
                                     maximumValue: 70) { (lower, upper) in
                    self.participantsAgeTextField.text = "\(lower) лет - \(upper) лет"
                    self.processController?.participantsAgeFrom = lower
                    self.processController?.participantsAgeTo = upper
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                    
                    return "От \(lower) лет до \(upper) лет"
                }
                
                alert.addAction(title: "Готово", style: .cancel)
                alert.show()
                
                return false
            }
        case .dateDetails:
            if textField == self.dateTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите время проведения")
                
                alert.addDatePicker(mode: .dateAndTime, date: processController?.date, minimumDate: Date(), maximumDate: Date().adding(days: 7)) { date in
                    textField.text = date.fullFormatted
                    self.processController?.date = date
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                }
                alert.addAction(title: "Готово", style: .cancel)
                alert.show()
                
                return false
            }
            
            if textField == self.durationTextField {
                let alert = UIAlertController(style: .actionSheet, title: "Выберите продолжительность")
                
                let durationValues: [[String]] = [(1...6).map { ($0 * 30).description }]
                alert.addPickerView(values: durationValues) { (vc, picker, index, values) in
                    self.durationTextField.text = "\(values[index.column][index.row]) минут"
                    self.processController?.duration = Int(values[index.column][index.row])
                    
                    self.isButtonEnabled = self.processController?.isCompleted(step: self.step) ?? false
                    self.errorLabel.text = nil
                }
                
                alert.addAction(title: "Готово", style: .cancel)
                alert.show()
                
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
}
