//
//  ForecastView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 30.03.25.
//
// 

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    
    // make sure that forecast, new location and color scheme are updated
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    // declare and monitor selected city
    @State private var selectedCity: City?
    
    // create an instance of weather manager
    let weatherManager = WeatherManager.shared
    
    // check if weather is still loading
    @State private var isLoading = false
    
    // declare and monitor current weather
    @State private var currentWeather: CurrentWeather?
    
    // declare and monitor daily weather
    @State private var dailyForecast: Forecast<DayWeather>?
    
    // prepare for presenting views
    @State private var showCityList: Bool = false
    @State private var showBirthDate: Bool = false
    @State private var showBackgroundImage: Bool = false
    
    // check if birth data are prsent
    @State private var isBirthDatePresent: Bool = true
    
    // check the given time zone
    @State private var timezone: TimeZone = .current
    
    // declare and monitor sun values
    @State private var sunrise: Date?
    @State private var sunset: Date?
    @State private var solarNoon: Date?

    // declare and monitor moon values
    @State private var currentMoonPhase: String?
    @State private var moonrise: Date?
    @State private var moonset: Date?

    // create an instance of ascendant sign
    var ascendantSign = AscendantSign()

    
    var body: some View {
        
        ZStack {
            VStack {
                // stack for header
                HStack {
                    if let selectedCity { // check if city is already present
                        Text(selectedCity.name)
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                    } else {
                        Text("Searching for city")
                            .font(.title2)
                            .foregroundStyle(.white)
                    }
                }
                // stack for date and time
                HStack {
                    Text("\(currentWeather?.date.getDayMonth().currentWeekDay ?? "Sunday"),")
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                    if let currentWeather = currentWeather {
                        Text("\(currentWeather.date.localDate(for: timezone)),")
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                        Text(currentWeather.date.localTime(for: timezone))
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                    }
                }
                
                VStack { // stack for weather data
                    if isLoading { // check if weather data are already prsent
                        ProgressView("Fetching Weather data ...")
                    } else {
                        HStack {
                            if let currentWeather = currentWeather {
                                CurrentWeatherDataView(currentWeather: currentWeather)
                            }
                        }
                    }
                }
                .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding(10)
                // task to check the async status and result of the query
                .task(id: locationManager.currentLocation) {
                    if let currentLocation = locationManager.currentLocation,
                        selectedCity == nil {
                        selectedCity = currentLocation
                    }
                }
                // task to check the selected city
                .task(id: selectedCity) {
                    if let selectedCity {
                        await fetchWeather(for: selectedCity)
                    }
                }
                // stack for sun data
                VStack {
                    Text("Sun")
                        .font(.title2)
                        .padding(.bottom, 1)
                    
                    if let sunrise = sunrise, let sunset = sunset, let solarNoon = solarNoon {
                        SunDataView(timezone: timezone, sunrise: sunrise, sunset: sunset,
                                    solarNoon: solarNoon)
                    }
                }
                .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding(10)
                // stack for moon data
                VStack {
                    MoonDataView(timezone: timezone, moonrise: moonrise, moonset: moonset,
                                 currentMoonPhase: currentMoonPhase)
                }
                .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding(10)
                // stack for zodiac sign data
                VStack {
                    Text("Current Zodiac Sign")
                        .font(.title2)
                        .padding(.bottom, 1)
                        
                    AscendantDataView(currentWeather: currentWeather,
                                      selectedCity: selectedCity)
                    
                    HStack {
                        if isBirthDatePresent {
                            HStack {
                                Text("Your sign:")
                                    .font(.subheadline)
                                    .foregroundStyle(.blue)
                                    .padding(.top, 5)
                                Text("Leo, Aszendant: Libra")
                                    .font(.subheadline)
                                    .padding(.top, 5)
                            }
                        } else {
                            Text("Enter your birth data:")
                                .font(.subheadline)
                                .padding(.top, 10)
                            
                            Button {
                                showBirthDate.toggle() // call birth date view to put in your birth data
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .padding(.bottom, 2)
                                    .padding(.top, 9)
                            }
                        }
                    }
                    
                    Text("Chinese Zodiac Sign:")
                        .font(.title2)
                        .padding(.top, 5)
                        .padding(.bottom, 1)
                    HStack {
                        Text(ChineseSigns.current())
                            .padding(.top, 1)
                            .padding(.bottom, 2)
                    }
                    if isBirthDatePresent {
                        HStack {
                            Text("Your sign:")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                                .padding(.top, 5)
                                .padding(.bottom, 3)
                            Text("Wood Rabbit")
                                .font(.subheadline)
                                .padding(.top, 5)
                                .padding(.bottom, 3)
                        }
                    }
                }
                .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
                .padding(.vertical, 10)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .padding(10)
                
                Spacer()
                
                // stack for footer
                HStack {
                    Spacer()
                    VStack {
                        Button {
                            showBackgroundImage.toggle() // call background image view to change image
                        } label: {
                            Image(systemName: "photo")
                        }
                        .padding()
                        .background(Color(.lightGray))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    VStack {
                        AttributionView()
                            .tint(.white)
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Button {
                            showCityList.toggle() // call cities list view to change city
                        } label: {
                            Image(systemName: "list.star")
                        }
                        .padding()
                        .background(Color(.lightGray))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .clipShape(Circle())
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Spacer()
                }
                .fullScreenCover(isPresented: $showCityList) {
                    CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
                }
                .fullScreenCover(isPresented: $showBirthDate) {
                    BirthDateView()
                }
                .fullScreenCover(isPresented: $showBackgroundImage) {
                    BackgroundImageView()
                }
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        selectedCity = locationManager.currentLocation
                        if let selectedCity {
                            Task {
                                await fetchWeather(for: selectedCity)
                            }
                        }
                    }
                }
                .task(id: locationManager.currentLocation) {
                    if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                        selectedCity = currentLocation
                    }
                }
            }
            .background(colorScheme == .dark ? Color.clear : Color.clear)
            .background {
                BackgroundView()
            }
        }
    }
    
    // get the weather and sun and moon data for the (new) given location
    func fetchWeather(for city: City) async {
        isLoading = true // set isLoading to true if weather data are not present yet
        // Apple's recommended task to fetch the weather for given location
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimeZone(for: city.clLocation)
            dailyForecast = await weatherManager.dailyForecast(for: city.clLocation)
            if let firstDayForecast = dailyForecast?.first {
                self.sunrise = firstDayForecast.sun.sunrise
                self.sunset = firstDayForecast.sun.sunset
                self.solarNoon = firstDayForecast.sun.solarNoon
                self.moonrise = firstDayForecast.moon.moonrise
                self.moonset = firstDayForecast.moon.moonset
                self.currentMoonPhase = firstDayForecast.moon.phase.rawValue
            }
        }
        isLoading = false // set to false again when data are arriving
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager()) // add location manager here
}

