//
//  MoonDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI

struct MoonDataView: View {
    
    let timezone: TimeZone
    let moonrise: Date?
    let moonset: Date?
    let currentMoonPhase: String?
    
    var body: some View {
        
        if let moonrise = moonrise, let moonset = moonset, let currentMoonPhase = currentMoonPhase,
           let moonPhaseEnum = MoonPhase(rawValue: currentMoonPhase) {
            
            Text("Moon")
                .font(.title2)
                .padding(.bottom, 1)
            
            HStack {
                Spacer()
                Image(systemName: "moonrise.fill")
                    .foregroundStyle(.blue)
                Text(moonrise.localTime(for: timezone))
                Spacer()
                Image(systemName: "moonset.fill")
                    .foregroundStyle(.blue)
                Text(moonset.localTime(for: timezone))
                Spacer()
            }
            
            let moonIllumination = Illumination().getCurrentIllumination()
            // get the correct localizable string with the help of the default key
            Text("Moon Phase: \(moonPhaseEnum.localizedString), \(moonIllumination)%")
                .padding(.top, 1)
        }
        
    }
}

