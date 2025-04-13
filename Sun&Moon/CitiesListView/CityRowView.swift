//
//  CitiesRowView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 02.04.25.
//

import SwiftUI
import WeatherKit

struct CityRowView: View {
    
    // instance of weatherManager singletion (shared)
    let weatherManager = WeatherManager.shared
    
    // observe states of these variables
    @Environment(LocationManager.self) var locationManager
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    @State private var timezone: TimeZone = .current
    
    // create a city variable for the preview/view
    let city: City
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let currentWeather {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.title)
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Text(currentWeather.date.localTime(for: timezone))
                                    .bold()
                            }
                            Spacer()
                            VStack {
                                let temp = weatherManager.tempFormatter.string(from: currentWeather.temperature)
                                Text(temp)
                                    .font(.title)
                                    .fixedSize(horizontal: true, vertical: true)
                                Text(currentWeather.condition.description.localizedCapitalized)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .task(id: city) {
            await(fetchWeather(for: city))
        }
    }
    // get the weather for the new given location
    func fetchWeather(for city: City) async {
        isLoading = true // set isLoading to true if weather data are not present yet
        // Apple's recommended task to fetch the weather for given location
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimeZone(for: city.clLocation)
        }
        isLoading = false // set to false again when data are arriving
    }
}

#Preview {
    CityRowView(city: City.mockCurrent)
        .environment(LocationManager())
}
