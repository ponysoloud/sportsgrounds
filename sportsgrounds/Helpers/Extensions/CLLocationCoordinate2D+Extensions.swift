//
//  CLLocationCoordinate2D+Extensions.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 16/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    init(withCoordinate coordinate: SGCoordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
