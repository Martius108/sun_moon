//
//  Sun_MoonApp.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 16.03.25.
//

import SwiftUI
import SwiftData

@main
struct Sun_MoonApp: App {
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if locationManager.isAuthorized {
                    ContentView()
                } else {
                    LocationDeniedView()
                }
            }
            .onAppear {
                locationManager.startLocationServices()
            }
        }
        .modelContainer(for: BirthDate.self) // prepare for SwiftData
        .environmentObject(locationManager)
    }
}
