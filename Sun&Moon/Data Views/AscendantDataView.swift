//
//  AscendantDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 12.04.25.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct AscendantDataView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather?
    let selectedCity: City?
    var ascendantSign = AscendantSign()
    
    var body: some View {
        
        if let currentWeather = currentWeather {
            ZodiacDataView(currentWeather: currentWeather)
        }
        
        HStack {
            Text("Ascendant:")
                .font(.system(size: 17))
                .padding(.bottom, 2)
            if let city = selectedCity {
                let ascendantSign = getCurrentAscendentZodiacSign(location: city.clLocation)
                Text(ascendantSign)
                    .font(.system(size: 17))
                    .padding(.bottom, 2)
            } else {
                Text("Ascendant unknown")
                    .font(.system(size: 17))
                    .padding(.bottom, 2)
            }
        }
    }
    
    func getCurrentAscendentZodiacSign(location: CLLocation) -> String {
        
        guard let currentWeather else { return "No weather data" }
        let (zodiacSign, debugOutput) = ascendantSign.calculateAscendantWithDebug(for: location, date: currentWeather.date)

        print(debugOutput)
        return zodiacSign
    }
}
