//
//  LocatiLocationDeniedView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 31.03.25.
//

import SwiftUI

// This View is called when Location Services are not allowed (yet).
struct LocationDeniedView: View {
    
    public var body: some View {
        ContentUnavailableView(
            label: {
                // Show location services logo
                Label("LocationServices", systemImage: "gear")
                    .padding(.vertical)
            },
            description: {
                // Describe the way to allow location services
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Tap on the button below and go to \"Privacy & Security\"")
                    Text("2. Tap on \"Location Services\"")
                    Text("3. Locate this APP and open it")
                    Text("4. Change the setting to \"Allow while using the APP\"")
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Alles linksbündig ausrichten
            },
            actions: {
                // Button which leads to location settings
                Button(action: {
                    UIApplication.shared.open(
                        URL(string: UIApplication.openSettingsURLString)!,
                        options: [:],
                        completionHandler: nil
                    )
                }) {
                    Text("Settings")
                        .padding(.top)
                }
            }
        )
    }
}

#Preview {
    LocationDeniedView()
}

