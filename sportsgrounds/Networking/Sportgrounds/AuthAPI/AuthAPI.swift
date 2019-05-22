//
//  AuthAPI.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import PromiseKit

struct AuthAPI: NetworkService {
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func login(email: String, password: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.login(email: email, password: password)
            provider.execute(request).done {
                response in
                
                switch response {
                case .data(_):
                    
                    let success: (SGTokenResponse) -> Void = { s in
                        seal.fulfill(s.token)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
            }.catch {
                error in
                seal.reject(error)
            }
        }
    }
    
    func register(email: String, password: String, name: String, surname: String, birthdate: Date) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.register(email: email, password: password, name: name, surname: surname, birthdate: birthdate.iso8601)
            provider.execute(request).done {
                response in
                
                switch response {
                case .data(_):
                    
                    let success: (SGTokenResponse) -> Void = { s in
                        seal.fulfill(s.token)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func logout(token: String) -> Promise<Void> {
        return Promise { seal in
            let request = AuthRequest.logout(token: token)
            provider.execute(request).done {
                response in
                
                switch response {
                case .data(_):
                    
                    let success: (SGBasicResponse) -> Void = { _ in }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        if f.status == "failure" {
                            let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                            seal.reject(error)
                        } else {
                            seal.fulfill(())
                        }
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
    
    func refresh(token: String) -> Promise<String> {
        return Promise { seal in
            let request = AuthRequest.refresh(token: token)
            provider.execute(request).done {
                response in
                
                switch response {
                case .data(_):
                    
                    let success: (SGTokenResponse) -> Void = { s in
                        seal.fulfill(s.token)
                    }
                    
                    let failure: (SGBasicResponse) -> Void = { f in
                        let error = SportsgroundsResponseError.serverFailureResponse(message: f.message)
                        seal.reject(error)
                    }
                    
                    do {
                        try response.extractResult(success: success, failure: failure)
                    } catch let error {
                        seal.reject(error)
                    }
                case .error(let error):
                    seal.reject(error)
                }
                }.catch {
                    error in
                    seal.reject(error)
            }
        }
    }
}
