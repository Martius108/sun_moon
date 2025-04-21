//
//  ZodiacData.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI
import WeatherKit

// View holding current zodiac sign data for content view
struct ZodiacDataView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let westernSignName = WesternSigns()
    
    var body: some View {
        let (day, month, _) = currentWeather.date.getDayMonth()
        let (name, element, symbol) = westernSignName.getName(day: day, month: month)
        
        HStack {
            Text(symbol)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .padding(.bottom, 4)
                .foregroundColor({
                    switch element {
                    case NSLocalizedString("Air", comment: ""): return .blue
                    case NSLocalizedString("Fire", comment: ""): return .red
                    case NSLocalizedString("Earth", comment: ""): return .green
                    default: return .yellow
                    }
                }())
            Text("\(name), Element: \(element)")
                .font(.system(size: 18))
        }
    }
}

