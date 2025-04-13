//
//  LocationManager.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 31.03.25.
//

import Foundation
import CoreLocation

// create an observable class as NSObject which confirms to the delegate protocol
@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager() // no need to observe this one
    
    var userLocation: CLLocation? // optional cllocation type
    var currentLocation: City? // optional city name
    var isAuthorized = false // check for user authorization
    
    // override initializer to store the delegate values
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // create  a function to check the authorization status and to allow to update location
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // create a function to get the city from the given location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
        
        if let userLocation {
            Task {
                let name = await getLocationName(for: userLocation)
                currentLocation = City(
                    name: name,
                    latitude: userLocation.coordinate.latitude,
                    longitude: userLocation.coordinate.longitude
                )
            }
        }
    }
    
    // create a function to return the city name
    func getLocationName(for location: CLLocation) async -> String {
        let name = try? await CLGeocoder().reverseGeocodeLocation(location).first?.locality
        return name ?? "Unknown Location"
    }
    
    // get the timeZone of the selected location
    func getTimeZone(for location: CLLocation) async -> TimeZone {
        let timezone = try? await CLGeocoder().reverseGeocodeLocation(location).first?.timeZone
        return timezone ?? .current
    }
    
    // function to handle all authorization cases
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
            
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            isAuthorized = false
            
        default :
            startLocationServices()
        }
    }
    
    // function for error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
