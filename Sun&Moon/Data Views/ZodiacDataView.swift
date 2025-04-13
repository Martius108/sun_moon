//
//  ZodiacData.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI
import WeatherKit

struct ZodiacDataView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let westernSignName = WesternSigns()
    
    var body: some View {
        
        HStack {
            
            let (name, element, symbol) = westernSignName.getName(day: currentWeather.date.getDayMonth().currentDay, month: currentWeather.date.getDayMonth().currentMonth)
            if (element == "Luft") {
                Text(symbol)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            } else if (element == "Feuer") {
                Text(symbol)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.red)
            } else if (element == "Erde") {
                Text(symbol)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
            } else {
                Text(symbol)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.yellow)
            }
            Text("\(name), Element: \(element)")
        }
    }
}
