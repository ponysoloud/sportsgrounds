//
//  AuthRequest.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

enum AuthRequest: Request {
    
    case login(email: String, password: String)
    case register(email: String, password: String, name: String, surname: String, birthdate: String)
    
    case logout(token: String)
    case refresh(token: String)
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .register:
            return "auth/register"
        case .logout:
            return "auth/logout"
        case .refresh:
            return "auth/refresh"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        case .logout:
            return .post
        case .refresh:
            return .post
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case let .login(email: email, password: password):
            let dict = [
                "email": email,
                "password": password
            ]
            return RequestParams.body(dict)
        case let .register(email: email, password: password, name: name, surname: surname, birthdate: birthdate):
            let dict = [
                "email": email,
                "password": password,
                "name": name,
                "surname": surname,
                "birthday": birthdate
            ]
            return RequestParams.body(dict)
        case .logout:
            return nil
        case .refresh:
            return nil
        }
    }
    
    var headers: [String : Any]? {
        switch self {
        case .login, .register:
            return nil
        case .logout(token: let token):
            return ["Authorization": "Bearer \(token)"]
        case .refresh(token: let token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
