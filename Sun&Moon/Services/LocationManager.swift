//
//  LocationManager.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 31.03.25.
//

import Foundation
import CoreLocation

// Create an observable class as NSObject which confirms to the delegate protocol
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @ObservationIgnored let manager = CLLocationManager() // no need to observe this one
    
    @Published var userLocation: CLLocation? // optional cllocation value
    @Published var name: String? // optional city name
    @Published var isAuthorized = false // check for user authorization
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Override initializer to store the delegate values
    override init() {
        super.init()
        manager.delegate = self
    }
    
    // Create  a function to check the authorization status and to allow to update location
    func startLocationServices() {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            isAuthorized = false
        }
    }
    
    // Create a function to get the city from the given location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    // Create a function to return the city name
    func getLocationName(for location: CLLocation) async -> String {
        let name = try? await CLGeocoder().reverseGeocodeLocation(location).first?.locality
        return name ?? NSLocalizedString("Unknown City", comment: "")
    }
    
    // Get the timezone of the selected location
    func getTimeZone(for location: CLLocation) async -> TimeZone {
        let timezone = try? await CLGeocoder().reverseGeocodeLocation(location).first?.timeZone
        return timezone ?? .current
    }

    // Geocode a city name into coordinates for the manual fallback flow.
    func geocodeLocation(for city: String) async -> CLLocation? {
        let cleaned = city.cleanedCityName()
        guard !cleaned.isEmpty else { return nil }

        let placemarks = try? await CLGeocoder().geocodeAddressString(cleaned)
        return placemarks?.first?.location
    }
    
    // Function to handle all authorization cases
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
            
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
            
        case .denied:
            isAuthorized = false
            userLocation = nil
            
        default :
            startLocationServices()
        }
    }
    
    // Function for error handling
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
