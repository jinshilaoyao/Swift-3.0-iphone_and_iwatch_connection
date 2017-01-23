//
//  MapManager.swift
//  weather_swift
//
//  Created by yesway on 2017/1/2.
//  Copyright © 2017年 joker. All rights reserved.
//

import UIKit
import CoreLocation

protocol MapManagerLocationDelegate: NSObjectProtocol {
    func mapManagerServerClosed(manager: MapManager)
    func mapManager(manager: MapManager, didFailed error: Error)
    func mapManager(manager: MapManager, didUpateAndGetLastCllocation location: CLLocation)
}

class MapManager: NSObject {
    
    
    public weak var mapDelegate: MapManagerLocationDelegate?
    
    public var authorizationStatus: CLAuthorizationStatus {
        get {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    private var locationManager: CLLocationManager = CLLocationManager()

    func start() {
        locationManager.delegate = self
        
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
}
extension MapManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startUpdatingLocation()
        let location = locations.last!
        mapDelegate?.mapManager(manager: self, didUpateAndGetLastCllocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (CLLocationManager.locationServicesEnabled()) {
            mapDelegate?.mapManager(manager: self, didFailed: error)
        } else {
            mapDelegate?.mapManagerServerClosed(manager: self)
        }
    }
}
