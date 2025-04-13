//
//  LocatiLocationDeniedView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 31.03.25.
//

import SwiftUI

struct LocationDeniedView: View {
    
    public var body: some View {
        ContentUnavailableView(label: {
            Label("LocationServices", systemImage: "gear")
                .padding(.vertical)
        },
                 description: {
            
            HStack {
                Text("1. Tap on the button below and go to \"Privacy & Security\"")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("2. Tap on \"Location Services\"")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("3. Locate this APP and open it")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("4. Change the setting to \"Allow while using the APP\"")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        },
                               actions: {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil
                )

            }) {
                Text("Settings")
            }
        })
    }
}

#Preview {
    LocationDeniedView()
}

