//
//  UserAPI.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 19/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import PromiseKit

struct UserAPI: NetworkService {
    
    private let provider: Provider
    
    init(provider: Provider) {
        self.provider = provider
    }
    
    func getUser(withToken token: String, userId: Int? = nil) -> Promise<SGUser> {
        return Promise { seal in
            let request = UserRequest.getUser(token: token, userId: userId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGUserResponse) -> Void = { s in
                        seal.fulfill(s.user)
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
    
    func editUser(withToken token: String, image: UIImage) -> Promise<SGUser> {
        return Promise { seal in
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                seal.reject(UserAPIError.imageIsNotConvertibleToJpegData)
                return
            }
            
            let request = UserRequest.editUser(token: token, imageName: "image.jpeg", imageData: imageData)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGUserResponse) -> Void = { s in
                        seal.fulfill(s.user)
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
    
    func getTeammates(withToken token: String, userId: Int, count: Int?) -> Promise<[SGUser]> {
        return Promise { seal in
            let request = UserRequest.getTeammates(token: token, userId: userId, count: count)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGUsersResponse) -> Void = { s in
                        seal.fulfill(s.users)
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
    
    func rateUser(withToken token: String, userId: Int) -> Promise<SGUser> {
        return Promise { seal in
            let request = UserRequest.rateUser(token: token, userId: userId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGUserResponse) -> Void = { s in
                        seal.fulfill(s.user)
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
    
    func unrateUser(withToken token: String, userId: Int) -> Promise<SGUser> {
        return Promise { seal in
            let request = UserRequest.unrateUser(token: token, userId: userId)
            provider.execute(request).done {
                response in
                switch response {
                case .data(_):
                    
                    let success: (SGUserResponse) -> Void = { s in
                        seal.fulfill(s.user)
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

enum UserAPIError: Error {
    case imageIsNotConvertibleToJpegData
}

