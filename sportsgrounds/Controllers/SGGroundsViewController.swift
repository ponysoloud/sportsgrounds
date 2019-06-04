//
//  SGGroundsViewController.swift
//  sportgrounds
//
//  Created by Alexander Ponomarev on 14/05/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit
import GoogleMaps
import PromiseKit

class SGGroundsViewController: SGFlowViewController {
    
    let user: SGApplicationUser
    
    var groundAPI: GroundAPI?
    var onGround: ((Int) -> Void)?
    
    // MARK: - Private static properties
    
    private static let defaultLocation: CLLocation = CLLocation(latitude: 55.750782, longitude: 37.616004)
    private static let defaultZoomLevel: Float = 11.0
    
    private static let minZoomLevelForReceivingGrounds: Float = 14.0
    
    private static var mapStyle: GMSMapStyle {
        let mapStyleData = getLocalFile(withName: "MapStyle", extension: "json")!
        let mapStyleString = String(data: mapStyleData, encoding: .utf8)!
        return try! GMSMapStyle(jsonString: mapStyleString)
    }
    
    // MARK: - Private properties
    
    private lazy var locationButtonView: SGLocationView = {
        let locationView = SGLocationView.view
        locationView.locationButton?.addTarget(self,
                                               action: #selector(locationButtonTouchUpInside(_:)),
                                               for: .touchUpInside)
        view.addSubview(locationView)
        return locationView
    }()
    
    private let mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withTarget: SGGroundsViewController.defaultLocation.coordinate,
                                              zoom: SGGroundsViewController.defaultZoomLevel)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.mapStyle = SGGroundsViewController.mapStyle
        mapView.setMinZoom(9, maxZoom: 25)
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    
    private let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 15
        locationManager.startUpdatingLocation()
        
        return locationManager
    }()
    
    private var zoomLevel: Float = 11.0
    
    private var followUserLocation: Bool = false {
        didSet {
            self.locationButtonView.locationButton?.isSelected = followUserLocation
        }
    }
    
    private var markers: Set<GMSMarker> = []
    
    // MARK: - UIViewController hierarchy
    
    init(user: SGApplicationUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addConstraintsToSubviews()
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Public functions
    
    func showGrounds(inLocation location: SGCoordinate) {
        let target = CLLocationCoordinate2D(withCoordinate: location)
        let camera = GMSCameraPosition.camera(withTarget: target, zoom: SGGroundsViewController.minZoomLevelForReceivingGrounds)
        mapView.animate(to: camera)
    }
    
    // MARK: - Private functions
    
    private func addConstraintsToSubviews() {
        locationButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButtonView.heightAnchor.constraint(equalToConstant: 50.0),
            locationButtonView.heightAnchor.constraint(equalTo: locationButtonView.widthAnchor),
            locationButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
    }
    
    private func marker(withGroundLocation groundLocation: SGGroundLocation) -> GMSMarker {
        let position = CLLocationCoordinate2D(withCoordinate: groundLocation.location)
        let marker = GMSMarker(position: position)
        
        if let status = groundLocation.status {
            switch status {
            case .processing:
                marker.icon = UIImage(named: "map.icon.marker.green")
            case .scheduled:
                marker.icon = UIImage(named: "map.icon.marker.blue")
            case .ended, .canceled:
                marker.icon = UIImage(named: "map.icon.marker.white")
            }
        } else {
            marker.icon = UIImage(named: "map.icon.marker.white")
        }
        
        marker.userData = groundLocation.id
        marker.appearAnimation = .none
        marker.isFlat = true
        return marker
    }
    
    @objc private func locationButtonTouchUpInside(_ sender: UIButton) {
        guard let userLocation = self.mapView.myLocation else {
            return
        }
        
        self.followUserLocation = true

        let zoom: Float
        if zoomLevel < SGGroundsViewController.minZoomLevelForReceivingGrounds {
            zoom = SGGroundsViewController.minZoomLevelForReceivingGrounds
        } else {
            zoom = zoomLevel
        }
        
        let camera = GMSCameraPosition.camera(withTarget: userLocation.coordinate, zoom: zoom)
        mapView.animate(to: camera)
    }
}

extension SGGroundsViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let groundId = marker.userData as? Int else {
            return false
        }
        self.onGround?(groundId)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.zoomLevel = mapView.camera.zoom
        
        if self.zoomLevel >= SGGroundsViewController.minZoomLevelForReceivingGrounds {
            
            let visibleRegion = mapView.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(region: visibleRegion)
            
            groundAPI?.cancelAllTasks()
            groundAPI?.getGroundsLoocations(withToken: self.user.token, northEastCoordinate: bounds.northEast, southWestCoordinate: bounds.southWest).done {
                [unowned self]
                locations in
                
                self.mapView.clear()
                self.markers = Set(locations.map { self.marker(withGroundLocation: $0) })
                self.markers.forEach {
                    $0.map = self.mapView
                }
            }.catch {
                error in
                print("Error: \(error)")
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture {
            self.followUserLocation = false
        }
    }
}

extension SGGroundsViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        if followUserLocation {
            let camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel)
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
