//
//  ContentView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 16.04.25.
//

import SwiftUI
import WeatherKit
import CoreLocation
import SwiftData

// Initial View holding all data
struct ContentView: View {
    
    // Prepare for SwiftData
    @Query var birthDates: [BirthDate]
    @State private var showEditView = false
    
    // Set up the location and the weather manager
    @EnvironmentObject var locationManager: LocationManager
    let weatherManager = WeatherManager.shared
    
    // Set up and monitor all network, weather, location and timezone data
    @StateObject private var networkMonitor = NetworkMonitor()
    @State private var currentWeather: CurrentWeather?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var timezone: TimeZone = .current
    private let fallbackLocation = CLLocation(latitude: 52.46, longitude: 13.42)
    var currentLocation: CLLocation {
        locationManager.userLocation ?? fallbackLocation
    }
    // Check if weather is still loading
    @State private var isLoading = false
    @State private var cityName: String?
    
    // Declare and monitor sun values
    @State private var sunrise: Date?
    @State private var sunset: Date?
    @State private var solarNoon: Date?
    
    // Declare and monitor moon values
    @State private var currentMoonPhase: String?
    @State private var moonrise: Date?
    @State private var moonset: Date?
    
    var body: some View {
        ZStack {
            Image(.image2)
                .imageStyle()
            VStack { // Main VStack
                HStack { // header city name
                    Text(cityName ?? (isLoading ? "Loading City ..." : "Unknown City"))
                        .font(.system(size: 26, weight: .regular, design: .default))
                        .foregroundStyle(.white)
                        .padding(.top, 3)
                }
                HStack { // Header date + time
                    Text("\(currentWeather?.date.getDayMonth().weekday ?? NSLocalizedString("Unknown Date", comment: "")),")
                        .textStyle1()
                    if let currentWeather = currentWeather {
                        Text("\(currentWeather.date.localDate(for: timezone))")
                            .textStyle1()
                    }
                }
                // Weather VStack
                VStack {
                    if isLoading { // check if weather data are already present
                        ProgressView("Fetching Weather data ...")
                    } else {
                        HStack {
                            if let currentWeather = currentWeather {
                                CurrentWeatherDataView(currentWeather: currentWeather)
                                let windInfo = windSymbols(for: currentWeather.wind.speed)
                                Image(systemName: windInfo)
                            } else {
                                Text("No Weather data available")
                            }
                        }
                    }
                }
                .vstackStyle()
                // Sun VStack
                VStack {
                    Text("Sun")
                        .headerStyle()
                    if let sunrise = sunrise, let sunset = sunset, let solarNoon = solarNoon {
                        SunDataView(timezone: timezone, sunrise: sunrise, sunset: sunset,
                                    solarNoon: solarNoon)
                    } else {
                        Text("No Sun data available")
                    }
                }
                .vstackStyle()
                // Moon VStack
                VStack {
                    Text("Moon")
                        .headerStyle()
                    if let moonrise = moonrise, let moonset = moonset, let currentMoonPhase = currentMoonPhase,
                       let moonPhaseEnum = MoonPhase(rawValue: currentMoonPhase) {
                        MoonDataView(timezone: timezone, moonrise: moonrise, moonset: moonset)
                    
                        let moonIllumination = Illumination().getCurrentIllumination()
                        // get the correct localized string with the help of the default key
                        Text("Moon Phase: \(moonPhaseEnum.localizedString), \(moonIllumination)%")
                            .padding(.top, 1)
                            .padding(.bottom, 4)
                    } else {
                        Text("No Moon data available")
                    }
                }
                .vstackStyle()
                // Zodiac sign VStack
                VStack {
                    Text("Current Zodiac Sign")
                        .font(.title2)
                    let location = currentLocation
                    AscendantDataView(currentWeather: currentWeather, selectedLocation: location)
                    
                    HStack {
                        if let birthDate = birthDates.first {
                            YourSignDataView(birthDate: birthDate)
                            Text("")
                            Button {
                                showEditView = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.system(size: 26))
                                    .padding(.bottom, 7)
                            }
                        } else {
                            Text("Get your Zodiac Sign: ")
                                .font(.system(size: 17))
                            Button {
                                showEditView = true
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.system(size: 30))
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showEditView) {
                        BirthDateView(existingEntry: birthDates.first)
                    }
                }
                .vstackStyle()
                // Chinese zodiac sign VStack
                VStack {
                    Text("Chinese Zodiac Sign")
                        .headerStyle()
                    ChineseSignDataView(birthDates: birthDates)
                }
                .vstackStyle()
                Spacer()
                // attributionView stack
                HStack {
                    AttributionView(networkMonitor: networkMonitor)
                        .font(.system(size: 13))
                        .frame(width: 140, alignment: .center)
                }
            }
            .task(id: locationManager.userLocation) { // if userLocation changes
                let location = currentLocation
                    if locationManager.userLocation == nil {
                        print("Using fallback location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    // optionally try to start location services if not authorized/available
                    if !locationManager.isAuthorized {
                         locationManager.startLocationServices()
                    }
                } else {
                    print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                }
                print("Location updated, fetching weather for \(location)")
                await fetchWeather(for: location)
            }
            .task(id: networkMonitor.isConnected) {
                guard networkMonitor.isConnected else { return }
                
                if let location = locationManager.userLocation {
                    await fetchWeather(for: location)
                } else {
                    print("No location available")
                }
            }


        }
        .preferredColorScheme(.dark)
    }
    // Fetching current weather
    func fetchWeather(for userLocation: CLLocation) async {
        // Perform async operations in a detached task, updating UI on MainActor
        Task.detached { @MainActor in
            // fetch weather, forecast, and location name concurrently
            async let currentWeatherData = weatherManager.currentWeather(for: userLocation)
            async let dailyForecastData = weatherManager.dailyForecast(for: userLocation)
            async let fetchedCityName = locationManager.getLocationName(for: userLocation)

            // Use await in async operation
            let (fetchedCurrentWeather, fetchedDailyForecast, fetchedName) = await (currentWeatherData, dailyForecastData, fetchedCityName)

            // Update state variables on MainActor
            self.currentWeather = fetchedCurrentWeather
            self.dailyForecast = fetchedDailyForecast
            self.cityName = fetchedName

            // Extract sun/moon data
            if let firstDayForecast = fetchedDailyForecast?.first {
                self.sunrise = firstDayForecast.sun.sunrise
                self.sunset = firstDayForecast.sun.sunset
                self.solarNoon = firstDayForecast.sun.solarNoon
                self.moonrise = firstDayForecast.moon.moonrise
                self.moonset = firstDayForecast.moon.moonset
                self.currentMoonPhase = firstDayForecast.moon.phase.rawValue
            } else {
                 // Clear sun/moon data if there is no forecast
                 self.sunrise = nil
                 self.sunset = nil
                 self.solarNoon = nil
                 self.moonrise = nil
                 self.moonset = nil
                 self.currentMoonPhase = nil
            }
            // Finish loading (success)
            self.isLoading = false
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager()) // Add location manager here
}
