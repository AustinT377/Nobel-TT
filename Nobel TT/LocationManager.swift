//
//  LocationManager.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/21/20.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    static let shared = LocationManager()

    func requestLocation() {
        locationManager.delegate = self
        
        let status = locationManager.authorizationStatus
                
        //can be used to take actions based on type of authorization
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            return
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        self.requestLocation()
        
        let defaultLocation = CLLocation.init(latitude: 37.4841833, longitude: -122.1497602)

        guard let location = locationManager.location else {return defaultLocation}
        
        return location
    }
    
    
    func getDistance(userLocation: CLLocation, laureatesLocation: CLLocation) -> Double{
        
        return userLocation.distance(from: laureatesLocation) / 1000
    }
}
