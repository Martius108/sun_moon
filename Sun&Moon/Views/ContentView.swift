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
    @Environment(\.scenePhase) private var scenePhase
    
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
    @State private var manualLocation: CLLocation?
    @State private var manualCityInput = ""
    @State private var showManualCityAlert = false
    @State private var showManualCityErrorAlert = false
    private let fallbackLocation = CLLocation(latitude: 52.46, longitude: 13.42)
    var currentLocation: CLLocation {
        manualLocation ?? locationManager.userLocation ?? fallbackLocation
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
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Text(cityName ?? (isLoading ? "Loading City ..." : "Unknown City"))
                            .font(.system(size: 26, weight: .regular, design: .default))
                            .foregroundStyle(.white)
                            .padding(.top, 3)
                    }
                    HStack {
                        Text("\(currentWeather?.date.getDayMonth().weekday ?? NSLocalizedString("Unknown Date", comment: "")),")
                            .textStyle1()
                        if let currentWeather = currentWeather {
                            Text("\(currentWeather.date.localDate(for: timezone))")
                                .textStyle1()
                        }
                    }
                    VStack {
                        if isLoading {
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
                    VStack {
                        Text("Moon")
                            .headerStyle()
                        if let currentMoonPhase = currentMoonPhase,
                           let moonPhaseEnum = MoonPhase(rawValue: currentMoonPhase) {
                            MoonDataView(timezone: timezone, moonrise: moonrise, moonset: moonset)

                            let moonIllumination = Illumination().getCurrentIllumination()
                            Text("Moon Phase: \(moonPhaseEnum.localizedString), \(moonIllumination)%")
                                .padding(.top, 1)
                                .padding(.bottom, 4)
                        } else {
                            Text("No Moon data available")
                        }
                    }
                    .vstackStyle()
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
                    VStack {
                        Text("Chinese Zodiac Sign")
                            .headerStyle()
                        ChineseSignDataView(birthDates: birthDates)
                    }
                    .vstackStyle()
                    HStack {
                        AttributionView(networkMonitor: networkMonitor)
                            .font(.system(size: 13))
                            .frame(width: 140, alignment: .center)
                    }
                    .padding(.bottom, 8)
                }
                .frame(maxWidth: 700)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
            .task(id: locationManager.userLocation) {
                let location = currentLocation
                if locationManager.userLocation == nil {
                    print("Using fallback location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    if !locationManager.isAuthorized {
                        locationManager.startLocationServices()
                    }
                } else {
                    print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                }
                print("Location updated, fetching weather for \(location)")
                await fetchWeather(for: location)
            }
            .task {
                if !networkMonitor.isConnected {
                    print("Device is offline at launch — waiting for reconnection...")
                    Task {
                        while !networkMonitor.isConnected {
                            try? await Task.sleep(nanoseconds: 1_000_000_000)
                        }
                        print("Network reconnected — fetching weather.")
                        if let location = locationManager.userLocation {
                            await fetchWeather(for: location)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            handleAuthorizationStatus(locationManager.authorizationStatus)
        }
        .onChange(of: locationManager.authorizationStatus) { _, status in
            handleAuthorizationStatus(status)
        }
        .onChange(of: networkMonitor.isConnected) { _, isConnected in
            guard isConnected else { return }
            Task {
                await reloadCurrentLocationData()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active else { return }
            locationManager.startLocationServices()
            guard networkMonitor.isConnected else { return }
            Task {
                await reloadCurrentLocationData()
            }
        }
        .alert("Location Access Denied", isPresented: $showManualCityAlert) {
            TextField("Enter City", text: $manualCityInput)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
            Button("Use City") {
                Task {
                    await applyManualCity()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter a city to load weather, sun, moon, and zodiac data without location access.")
        }
        .alert("City Not Found", isPresented: $showManualCityErrorAlert) {
            Button("OK") {
                showManualCityAlert = true
            }
        } message: {
            Text("Please enter a valid city name.")
        }
    }
    // Fetching current weather
    func fetchWeather(for userLocation: CLLocation) async {
        await MainActor.run {
            isLoading = true
        }
        // Perform async operations in a detached task, updating UI on MainActor
        Task.detached { @MainActor in
            // fetch weather, forecast, and location name concurrently
            async let currentWeatherData = weatherManager.currentWeather(for: userLocation)
            async let dailyForecastData = weatherManager.dailyForecast(for: userLocation)
            async let fetchedCityName = locationManager.getLocationName(for: userLocation)
            async let fetchedTimeZone = locationManager.getTimeZone(for: userLocation)

            // Use await in async operation
            let (fetchedCurrentWeather, fetchedDailyForecast, fetchedName, fetchedZone) = await (currentWeatherData, dailyForecastData, fetchedCityName, fetchedTimeZone)

            // Update state variables on MainActor
            self.currentWeather = fetchedCurrentWeather
            self.dailyForecast = fetchedDailyForecast
            self.cityName = fetchedName
            self.timezone = fetchedZone

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

    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        guard manualLocation == nil else { return }
        if status == .denied || status == .restricted {
            showManualCityAlert = true
        }
    }

    private func applyManualCity() async {
        let cleanedCity = manualCityInput.cleanedCityName()
        guard !cleanedCity.isEmpty else {
            showManualCityErrorAlert = true
            return
        }

        guard let location = await locationManager.geocodeLocation(for: cleanedCity) else {
            showManualCityErrorAlert = true
            return
        }

        manualCityInput = cleanedCity
        manualLocation = location
        cityName = cleanedCity
        await fetchWeather(for: location)
    }

    private func reloadCurrentLocationData() async {
        await fetchWeather(for: currentLocation)
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager()) // Add location manager here
}
