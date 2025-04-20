//
//  MoonDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI

struct MoonDataView: View {
    
    let timezone: TimeZone
    let moonrise: Date
    let moonset: Date
    
    var body: some View {
        
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
    }
}

