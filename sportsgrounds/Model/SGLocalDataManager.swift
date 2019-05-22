//
//  SGLocalDataManager.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGLocalDataManager {
    
    private enum UserDefaultsKey: String {
        case email = "email"
        case token = "token"
    }
    
    private let userDefaults: UserDefaults
    private let keychainConfiguration: SGKeychainConfiguration
    
    init(userDefaults: UserDefaults = UserDefaults.standard, keychainConfiguration: SGKeychainConfiguration) {
        self.userDefaults = userDefaults
        self.keychainConfiguration = keychainConfiguration
    }
    
    // MARK: - Save
    
    func save(token: String) {
        userDefaults.set(token, forKey: UserDefaultsKey.token.rawValue)
    }
    
    func save(email: String) {
        userDefaults.set(email, forKey: UserDefaultsKey.email.rawValue)
    }
    
    // MARK: - Get
    
    func getToken() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.token.rawValue) as? String
    }
    
    func getEmail() -> String? {
        return userDefaults.value(forKey: UserDefaultsKey.email.rawValue) as? String
    }
    
    // MARK: - Clear
    
    func removeToken() {
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)
    }
    
    func clearLocalData() {
        userDefaults.removeObject(forKey: UserDefaultsKey.token.rawValue)
        userDefaults.removeObject(forKey: UserDefaultsKey.email.rawValue)
    }
}
