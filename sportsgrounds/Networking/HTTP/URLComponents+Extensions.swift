//
//  URLComponents+Extensions.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

extension URLComponents {

    mutating func addQueryItems(_ queryItems: [URLQueryItem]) {
        if self.queryItems == nil {
            self.queryItems = []
        }

        self.queryItems?.append(contentsOf: queryItems)
    }
}
