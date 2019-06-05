//
//  SGKeychainConfiguration.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

protocol SGKeychainConfiguration {

    var serviceName: String { get }
    
    var accessGroup: String? { get }
}
