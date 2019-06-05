//
//  Dictionary+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {

    /**
     Add key-value pair where value is optional. If value is nil, pair doesn't add.
     */
    mutating func addPair(key: Key, value: Value?) {
        guard let val = value else {
            return
        }

        self[key] = val
    }
}

extension Dictionary where Key == String, Value == String? {

    /**
     Returns copy of self with unwrapped values.
     */
    func unwrapped() -> [String: String] {
        var unwrapped: [String: String] = [:]

        for i in self {
            unwrapped.addPair(key: i.key, value: i.value)
        }

        return unwrapped
    }
}
