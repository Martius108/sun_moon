//
//  Cities.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 31.03.25.
//

import Foundation
import CoreLocation

// city must be identifiable and hashable for renewing it's name and coordinates
struct City: Identifiable, Hashable {
    
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    // get coordinates for given location
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    // set location from coordinates
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static var cities: [City] = {
        [
            .init(name: "Berlin", latitude: 52.4616, longitude: 13.4189),
            .init(name: "New York", latitude: 40.7128, longitude: -74.0060),
            .init(name: "London", latitude: 51.5074, longitude: -0.1278),
            .init(name: "San Francisco", latitude: 37.7747, longitude: -122.4182),
            .init(name: "Melbourne", latitude: -37.8141, longitude: 144.9633),
            .init(name: "Tokyo", latitude: 35.6895, longitude: 139.6917)
        ]
    }()
    
    static var mockCurrent: City {
        .init(name: "Berlin", latitude: 52.4616, longitude: 13.4189)
    }
}
