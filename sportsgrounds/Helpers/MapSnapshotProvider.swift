//
//  MapSnapshotProvider.swift
//  sportsgrounds
//
//  Created by Alexander Ponomarev on 22/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import Foundation
import UIKit
import GoogleStaticMapsKit

enum MapSnapshotProvider {
    
    private static let mapStyles: [Style] = {
        let path = Bundle.main.url(forResource: "MapStyle", withExtension: "json")!
        let styles = StylesImporter.fromJson(path: path).styles
        
        return styles
    }()
    
    private static func marker(forLocation locationCenter: LocationCenter) -> Marker {
        return Marker(location: [locationCenter], color: MarkerColor.red, label: nil, size: MarkerSize.small)
    }
    
    static func snapshotUrl(withSize size: CGSize, markerLocation: (latitude: Double, longitude: Double)) -> URL? {
        let locationCenter = LocationCenter.geo(latitude: markerLocation.latitude, longitude: markerLocation.longitude)
        let parameters = Parameters(size: ImageSize(width: Int(size.width), height: Int(size.height)), scale: 2, language: "ru", region: "ru")
        let location = Location(center: locationCenter, zoom: .custom(value: 13))
        let feature = Feature(styles: self.mapStyles, markers: [self.marker(forLocation: locationCenter)])
        return GoogleStaticMaps(location: location, parameters: parameters, feature: feature).toURL
    }
}
