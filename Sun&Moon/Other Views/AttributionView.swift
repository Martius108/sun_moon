//
//  AttributionView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 18.04.25.
//

import SwiftUI
import WeatherKit

/// A view displaying the attribution information for the weather data provider.
struct AttributionView: View {
    
    // Environment for changing the color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    // WeatherManager shared instance
    let weatherManager = WeatherManager.shared
    
    // State to hold the attribution data
    @State private var attribution: WeatherAttribution?
    @State private var isLoading = true  // To track the loading state
    
    var body: some View {
        VStack {
            // Check if attribution data is available
            if let attribution {
                AsyncImage(
                    url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL
                ) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .padding(.top, 10)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }
                Link("Legal Information", destination: attribution.legalPageURL)
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .padding(.bottom, 9)
            } else if isLoading {
                // If still loading, show a loading indicator
                ProgressView("Loading attribution...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            } else {
                // If attribution could not be loaded, show an error message
                Text("Attribution could not be loaded.")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }
        }
        .padding()
        .task {
            // Fetch the attribution asynchronously
            await loadAttribution()
        }
    }
    
    /// Asynchronously fetches the weather attribution data.
    private func loadAttribution() async {
        // Fetch attribution from the WeatherManager
        attribution = await weatherManager.weatherAttribution()
        isLoading = false // Update loading state once done
    }
}

#Preview {
    AttributionView()
}
