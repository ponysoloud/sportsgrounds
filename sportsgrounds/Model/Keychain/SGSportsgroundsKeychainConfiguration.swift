//
//  SGSportsgroundsConfiguratio.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
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
