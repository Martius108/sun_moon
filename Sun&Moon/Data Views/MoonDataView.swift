//
//  MoonDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI

// View holding moon data for content view
struct MoonDataView: View {
    
    let timezone: TimeZone
    let moonrise: Date?
    let moonset: Date?
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                if let moonrise {
                    Spacer()
                    Image(systemName: "moonrise.fill")
                        .foregroundStyle(.blue)
                    Text(moonrise.localTime(for: timezone))
                }
                if let moonset {
                    Spacer()
                    Image(systemName: "moonset.fill")
                        .foregroundStyle(.blue)
                    Text(moonset.localTime(for: timezone))
                }
                if moonrise != nil || moonset != nil {
                    Spacer()
                }
            }

            if moonrise == nil {
                Text("Moonrise is not expected today at this location.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            if moonset == nil {
                Text("Moonset is not expected today at this location.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
