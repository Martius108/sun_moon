//
//  WindSpeed.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 17.04.25.
//

import SwiftUI
import WeatherKit

// Create wind symbols
func windSymbols(for windSpeed: Measurement<UnitSpeed>) -> String {
    let kmh = windSpeed.converted(to: .kilometersPerHour).value

    switch kmh {
    case 0..<1:
        return ("")
    case 1..<6:
        return ("wind")
    case 6..<12:
        return ("wind")
    case 12..<20:
        return ("wind.circle")
    case 20..<29:
        return ("wind.circle")
    case 29..<39:
        return ("wind.circle.fill")
    case 39..<50:
        return ("wind.circle.fill")
    case 50..<62:
        return ("hurricane")
    case 62..<75:
        return ("hurricane")
    case 75..<89:
        return ("hurricane.circle")
    case 89..<101:
        return ("hurricane.circle")
    default:
        return ("")
    }
}
