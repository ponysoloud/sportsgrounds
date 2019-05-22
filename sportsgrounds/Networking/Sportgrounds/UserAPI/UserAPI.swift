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
}

