//
//  SGEditingEventProcess.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 04/06/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

struct SGEditingEventProcess {
    
    var title: String?
    var description: String?
    
    // MARK: - Public getters
    
    var isCompleted: Bool {
        return title != nil || description != nil
    }
}
