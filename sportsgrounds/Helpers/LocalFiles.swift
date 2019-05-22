//
//  SGLocalFile.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 15/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation

func getLocalFile(withName name: String, extension: String) -> Data? {
    
    guard let path = Bundle.main.path(forResource: name, ofType: `extension`) else {
        return nil
    }
    
    do {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        return data
    } catch {
        return nil
    }
}
