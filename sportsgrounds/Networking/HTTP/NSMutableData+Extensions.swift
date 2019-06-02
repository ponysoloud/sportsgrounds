//
//  NSMutableData+Extensions.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 03/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
