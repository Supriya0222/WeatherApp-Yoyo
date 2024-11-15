//
//  Untitled.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 13/11/2024.
//

import CoreLocation
import Combine
import Foundation


final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocation?
    @Published var userLocation: CLLocation?
    @Published var locationAuthorizationStatus: CLAuthorizationStatus?

    var manager = CLLocationManager()
    var isPermissionGranted: Bool = false
    
    func checkLocationAuthorization() -> String?{
        
        manager.delegate = self
        manager.startUpdatingLocation()
        var errorMessage: String?
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            errorMessage = .localized(.permissionsDeniedMessage)

            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            errorMessage = .localized(.permissionsDeniedMessage)
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            locationAuthorizationStatus = .authorizedAlways
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            locationAuthorizationStatus = .authorizedWhenInUse
            
            
        @unknown default:
            print("Location service disabled")
        
        }
        return errorMessage
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startLocationUpdates() {
            manager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startLocationUpdates()
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
             userLocation = location
             stopLocationUpdates() // Stop location updates after getting the first location
         }
         
        
        lastKnownLocation = locations.first
    }
}
