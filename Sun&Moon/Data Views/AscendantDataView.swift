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
    let selectedLocation: CLLocation
    var ascendantSign = AscendantSign()
    
    var body: some View {
        
        if let currentWeather = currentWeather {
            ZodiacDataView(currentWeather: currentWeather)
        }
        
        HStack {
            Text("Ascendant:")
                .font(.system(size: 17))
                .padding(.bottom, 2)
            let ascendantSign = getCurrentAscendentZodiacSign(location: selectedLocation)
                Text(ascendantSign)
                    .font(.system(size: 17))
                    .padding(.bottom, 2)
        }
    }
    
    func getCurrentAscendentZodiacSign(location: CLLocation) -> String {
        
        guard let currentWeather else { return NSLocalizedString("No weather data", comment: "") }
        let (zodiacSign) = ascendantSign.calculateAscendantWithDebug(for: location, date: currentWeather.date)
        return zodiacSign
    }
}
