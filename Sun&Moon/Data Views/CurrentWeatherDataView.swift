//
//  CurrentWeatherView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import SwiftUI
import WeatherKit

struct CurrentWeatherDataView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    
    var body: some View {
        
        Text(Image(systemName: currentWeather.symbolName))
            
        let temp = weatherManager.tempFormatter.string(from:
        currentWeather.temperature)
        Text(temp)
            .font(.title3)
        Text(currentWeather.condition.description.localizedCapitalized)
            .font(.title3)
    }
}
