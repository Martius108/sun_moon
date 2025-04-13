//
//  Untitled.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 30.03.25.
//
// 

import Foundation
import WeatherKit
import CoreLocation

// singleton class (shared) holding all the neccessary weather and location data
class WeatherManager {
    
    // static shared property = instance of this class
    static let shared = WeatherManager()
    // private shared property = instance of Apple's WeatherService class
    let service = WeatherService.shared
    
    // create a formatter to get the temperature always in the right format
    var tempFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
    
    // function to get async current weather for given location
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        // try to get the current weather data
        let currentWeather = await Task.detached(priority: .userInitiated) {
            // try to get the forecast data which are within the current weather package
            let forecast = try? await self.service.weather(
                for: location,
                including: .current
            )
            // return the forecast
            return forecast
        }.value // needs to be attached because a value is expected
        // return currentWeather as well
        return currentWeather
    }
    
    // function to get daily weather including sun and moon events
    func dailyForecast(for location: CLLocation) async -> Forecast<DayWeather>? {
        // try to get the daily weather data
        let dailyForecast = await Task.detached(priority: .userInitiated) {
            // try to get the forecast data which are within the daily weather package
            let forecast = try? await self.service.weather(
                for: location,
                including: .daily
            )
            return forecast
        }.value
        return dailyForecast
    }
    
    // get the optional weatherAttribution value
    func weatherAttribution() async -> WeatherAttribution? {
        let attribution = await Task(priority: .userInitiated) {
            return try? await self.service.attribution
        }.value
        return attribution
    }
}
