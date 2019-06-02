//
//  Integer+Extensions.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 24/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

extension Int {
    
    var formattedAge: String {
        let lastDigit = self % 10
        
        switch lastDigit {
        case 1:
            return "\(self) год"
        case 2, 3, 4:
            return "\(self) года"
        case 5, 6, 7, 8, 9, 0:
            return "\(self) лет"
        default:
            fatalError()
        }
    }
}
