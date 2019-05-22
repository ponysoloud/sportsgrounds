//
//  SGNetworkingDelay.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

func performWithDelay(block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: block)
}
