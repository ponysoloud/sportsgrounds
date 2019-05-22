//
//  SGAuthorizationStep.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 17/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

enum SGAuthorizationStep {
    case login
    case register
    
    var title: String {
        switch self {
        case .login:
            return "Авторизация"
        case .register:
            return "Регистрация"
        }
    }
    
    var subtitle: String {
        switch self {
        case .login:
            return "Введите эдрес электронной почты и пароль для входа"
        case .register:
            return "Возможно вы новенький, поэтому введите пожалуйста дополнительные данные"
        }
    }
}
