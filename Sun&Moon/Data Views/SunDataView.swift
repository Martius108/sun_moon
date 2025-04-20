//
//  SunDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI

struct SunDataView: View {
    
    let timezone: TimeZone
    let sunrise: Date
    let sunset: Date
    let solarNoon: Date
    
    var body: some View {
       
        HStack {
            Spacer()
            Image(systemName: "sunrise.fill")
                .foregroundStyle(.orange)
            Text(sunrise.localTime(for: timezone))
            Spacer()
            Image(systemName: "sunset.fill")
                .foregroundStyle(.orange)
            Text(sunset.localTime(for: timezone))
            Spacer()
        }
        Image(systemName: "sun.max.fill")
            .foregroundStyle(.orange)
        Text(solarNoon.localTime(for: timezone))
            .padding(.bottom, 1)
    }
}

