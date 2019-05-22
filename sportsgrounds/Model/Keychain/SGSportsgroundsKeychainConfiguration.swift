//
//  SGSportsgroundsConfiguratio.swift
//  wallet
//
//  Created by  me on 06/08/2018.
//  Copyright © 2018 zamzam. All rights reserved.
//

import Foundation

struct SGSportsgroundsKeychainConfiguration: SGKeychainConfiguration {
    
    var serviceName: String {
        return "SportgroundsService"
    }

    var accessGroup: String? {
        return nil
    }
}
