//
//  AscendantDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 12.04.25.
//

import SwiftUI
import WeatherKit
import CoreLocation

// View holding ascendant data for content view
struct AscendantDataView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather?
    let selectedLocation: CLLocation
    var ascendantSign = AscendantSign()
    
    var body: some View {
        
        if let currentWeather = currentWeather {
            ZodiacDataView(currentWeather: currentWeather)
        } else {
            Text("No Zodiac data available")
                .padding(.top, 1)
        }
        HStack {
            Text("Ascendant:")
                .font(.system(size: 17))
                .padding(.bottom, 1)
            let currentAscendantSign = getCurrentAscendentSign(location: selectedLocation)
                Text(currentAscendantSign)
                    .font(.system(size: 17))
                    .padding(.bottom, 1)
        }
    }
    
    func getCurrentAscendentSign(location: CLLocation) -> String {
        
        guard let currentWeather else { return NSLocalizedString("No data available", comment: "") }
        let (zodiacSign) = ascendantSign.calculateAscendantSign(for: location, date: currentWeather.date)
        return zodiacSign
    }
}
