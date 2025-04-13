//
//  CitiesListView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 01.04.25.
//

import SwiftUI
import WeatherKit

struct CitiesListView: View {
    
    // use dismiss to remove a view from a NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    let currentLocation: City?
    @Binding var selectedCity: City?
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    if let currentLocation {
                        CityRowView(city: currentLocation)
                            .onTapGesture {
                                selectedCity = currentLocation
                                dismiss()
                            }
                    }
                    ForEach(City.cities) { city in
                        CityRowView(city: city)
                            .onTapGesture {
                                selectedCity = city
                                dismiss()
                            }
                    }
                }
                .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
                .padding(.vertical, 2)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                .listRowBackground(Color.clear)
                .scrollContentBackground(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            
            .background {
                Image(.image7)
            }
        }

    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
}

