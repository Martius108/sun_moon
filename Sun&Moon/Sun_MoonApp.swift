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
            if locationManager.isAuthorized {
                ContentView()
            } else {
                LocationDeniedView()
            }
        }
        .modelContainer(for: BirthDate.self) // prepare for SwiftData
        .environmentObject(locationManager)
    }
}
