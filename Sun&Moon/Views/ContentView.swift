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

struct ContentView: View {
    
    // prepare for SwiftData
    @Query var birthDates: [BirthDate]
    @State private var showEditView = false
    
    // set up the location and the weather manager
    @EnvironmentObject var locationManager: LocationManager
    let weatherManager = WeatherManager.shared
    
    // current weather, current location and current timezone
    @State private var currentWeather: CurrentWeather?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var timezone: TimeZone = .current
    private let fallbackLocation = CLLocation(latitude: 52.46, longitude: 13.42)
    var currentLocation: CLLocation {
        locationManager.userLocation ?? fallbackLocation
    }
    // check if weather is still loading
    @State private var isLoading = false
    @State private var cityName: String?
    
    // declare and monitor sun values
    @State private var sunrise: Date?
    @State private var sunset: Date?
    @State private var solarNoon: Date?
    
    // declare and monitor moon values
    @State private var currentMoonPhase: String?
    @State private var moonrise: Date?
    @State private var moonset: Date?
    
    var body: some View {
        ZStack {
            Image(.image2)
                .imageStyle()
            VStack { // main VStack
                HStack { // header city name
                    Text(cityName ?? (isLoading ? "Loading City ..." : "Unknown City"))
                        .font(.system(size: 26, weight: .regular, design: .default))
                        .foregroundStyle(.white)
                }
                HStack { // header date + time
                    Text("\(currentWeather?.date.getDayMonth().weekday ?? "Sunday"),")
                        .textStyle1()
                    if let currentWeather = currentWeather {
                        Text("\(currentWeather.date.localDate(for: timezone)),")
                            .textStyle1()
                        Text(currentWeather.date.localTime(for: timezone))
                            .textStyle1()
                    }
                }
                // weather VStack
                VStack {
                    if isLoading { // check if weather data are already present
                        ProgressView("Fetching Weather data ...")
                    } else {
                        HStack {
                            if let currentWeather = currentWeather {
                                CurrentWeatherDataView(currentWeather: currentWeather)
                                let windInfo = windSymbols(for: currentWeather.wind.speed)
                                Image(systemName: windInfo)
                            }
                        }
                    }
                }
                .vstackStyle()
                // sun VStack
                VStack {
                    Text("Sun")
                        .headerStyle()
                    if let sunrise = sunrise, let sunset = sunset, let solarNoon = solarNoon {
                        SunDataView(timezone: timezone, sunrise: sunrise, sunset: sunset,
                                    solarNoon: solarNoon)
                    }
                }
                .vstackStyle()
                // moon VStack
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
                    }
                }
                .vstackStyle()
                // zodiac sign VStack
                VStack {
                    Text("Current Zodiac Sign")
                        .headerStyle()
                    let location = currentLocation
                    AscendantDataView(currentWeather: currentWeather, selectedLocation: location)
                    
                    HStack {
                        if let birthDate = birthDates.first {
                            HStack {
                                YourSignDataView(birthDate: birthDate)
                                Text("")
                                Button {
                                    showEditView = true
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 23))
                                        .padding(.bottom, 5)
                                }
                            }
                        } else {
                            Text("Get your Zodiac Sign: ")
                                .font(.system(size: 17))
                                .padding(.bottom, 3)
                            Button {
                                showEditView = true
                            } label: {
                                Image(systemName: "pencil.line")
                                    .font(.system(size: 27))
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $showEditView) {
                        BirthDateView(existingEntry: birthDates.first)
                    }
                }
                .vstackStyle()
                // zodiac sign VStack
                VStack {
                    Text("Chinese Zodiac Sign")
                        .headerStyle()
                    ChineseSignDataView(birthDates: birthDates)
                }
                .vstackStyle()
                Spacer()
                // attributionView stack
                HStack {
                    AttributionView()
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
        }
        .preferredColorScheme(.dark)
    }
    
    func fetchWeather(for userLocation: CLLocation) async {
        // perform async operations in a detached task, updating UI on MainActor
        Task.detached { @MainActor in
            // fetch weather, forecast, and location name concurrently
            async let currentWeatherData = weatherManager.currentWeather(for: userLocation)
            async let dailyForecastData = weatherManager.dailyForecast(for: userLocation)
            async let fetchedCityName = locationManager.getLocationName(for: userLocation)

            // use await in async operation
            let (fetchedCurrentWeather, fetchedDailyForecast, fetchedName) = await (currentWeatherData, dailyForecastData, fetchedCityName)

            // update state variables on MainActor
            self.currentWeather = fetchedCurrentWeather
            self.dailyForecast = fetchedDailyForecast
            self.cityName = fetchedName

            // extract sun/moon data
            if let firstDayForecast = fetchedDailyForecast?.first {
                self.sunrise = firstDayForecast.sun.sunrise
                self.sunset = firstDayForecast.sun.sunset
                self.solarNoon = firstDayForecast.sun.solarNoon
                self.moonrise = firstDayForecast.moon.moonrise
                self.moonset = firstDayForecast.moon.moonset
                self.currentMoonPhase = firstDayForecast.moon.phase.rawValue
            } else {
                 // clear sun/moon data if there is no forecast
                 self.sunrise = nil
                 self.sunset = nil
                 self.solarNoon = nil
                 self.moonrise = nil
                 self.moonset = nil
                 self.currentMoonPhase = nil
            }
            // finish loading (success)
            self.isLoading = false
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager()) // add location manager here
}
