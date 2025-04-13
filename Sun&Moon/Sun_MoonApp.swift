//
//  Sun_MoonApp.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 16.03.25.
//

import SwiftUI

@main
struct Sun_MoonApp: App {
    
    @State private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
    }
}
