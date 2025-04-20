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

/// Singleton class that manages weather-related data and interactions with WeatherKit.
class WeatherManager {
    
    // Shared instance of WeatherManager
    static let shared = WeatherManager()
    
    // WeatherService instance from Apple's WeatherKit
    private let service = WeatherService.shared
    
    // Formatter for temperature values
    var tempFormatter: MeasurementFormatter
    
    // Private initializer to ensure only one instance of WeatherManager
    private init() {
        // Setup the temperature formatter once during initialization
        tempFormatter = MeasurementFormatter()
        tempFormatter.numberFormatter.maximumFractionDigits = 1
    }
    
    /// Fetches the current weather for a given location.
    /// - Parameter location: The `CLLocation` object representing the location for which weather is requested.
    /// - Returns: A `CurrentWeather` object containing the current weather information, or `nil` if the request fails.
    func currentWeather(for location: CLLocation) async -> CurrentWeather? {
        do {
            // Request current weather data from WeatherKit
            let forecast = try await service.weather(for: location, including: .current)
            return forecast
        } catch {
            // Log the error and return nil if the request fails
            print("Failed to fetch current weather: \(error)")
            return nil
        }
    }
    
    /// Fetches the daily forecast for a given location, including sun and moon events.
    /// - Parameter location: The `CLLocation` object representing the location for which the daily forecast is requested.
    /// - Returns: A `Forecast<DayWeather>` object containing the daily weather information, or `nil` if the request fails.
    func dailyForecast(for location: CLLocation) async -> Forecast<DayWeather>? {
        do {
            // Request daily weather forecast from WeatherKit
            let forecast = try await service.weather(for: location, including: .daily)
            return forecast
        } catch {
            // Log the error and return nil if the request fails
            print("Failed to fetch daily forecast: \(error)")
            return nil
        }
    }
    
    /// Fetches the weather attribution information, which includes the attribution of the weather data provider.
    /// - Returns: A `WeatherAttribution` object containing attribution data, or `nil` if the request fails.
    func weatherAttribution() async -> WeatherAttribution? {
        do {
            // Request weather attribution information
            let attribution = try await service.attribution
            return attribution
        } catch {
            // Log the error and return nil if the request fails
            print("Failed to fetch weather attribution: \(error)")
            return nil
        }
    }
}
