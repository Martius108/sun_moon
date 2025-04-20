//
//  BirthDateView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 13.04.25.
//

import SwiftUI
import SwiftData

// This View enables the input of users birth and location data
struct BirthDateView: View {

    // Environment for accessing the data model context.
    @Environment(\.modelContext) private var modelContext
    // Environment for dismissing the current view.
    @Environment(\.dismiss) private var dismiss

    @State private var showInvalidCoordinates = false
    @State var existingEntry: BirthDate?
    @State private var city: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var date: Date = Date()
    @State private var time: Date = Date()

    // State to track focus on the latitude text field (for CustomTextField).
    @State private var isLatitudeFocusedInternal: Bool = false
    // State to track focus on the longitude text field (for CustomTextField).
    @State private var isLongitudeFocusedInternal: Bool = false

    // State to track focus for displaying the custom NumPad.
    @FocusState private var isLatitudeFocused: Bool
    @FocusState private var isLongitudeFocused: Bool

    var body: some View {
        ZStack {
            Image(.image1)
                .imageStyle()
                .ignoresSafeArea()
                .onTapGesture {
                    isLatitudeFocused = false
                    isLongitudeFocused = false
                }

            VStack(spacing: 20) {
                Text("Please enter your birth data")
                    .font(.headline)
                    .padding(.top)

                VStack(alignment: .leading, spacing: 12) {
                    Text("City")
                    TextField("City", text: $city)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                        .overlay(
                            HStack {
                                Spacer()
                                if !city.isEmpty {
                                    Button {
                                        city = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )

                    Text("Latitude")
                    CustomTextField(text: $latitude, isFocused: $isLatitudeFocusedInternal, keyboardType: .numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 32)
                        .onTapGesture {
                            isLatitudeFocused = true
                            isLongitudeFocused = false
                            isLatitudeFocusedInternal = true // Set the internal focus state
                        }
                        .overlay(
                            HStack {
                                Spacer()
                                if !latitude.isEmpty {
                                    Button {
                                        latitude = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )

                    Text("Longitude")
                    CustomTextField(text: $longitude, isFocused: $isLongitudeFocusedInternal, keyboardType: .numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 32)
                        .onTapGesture {
                            isLongitudeFocused = true
                            isLatitudeFocused = false
                            isLongitudeFocusedInternal = true // Set the internal focus state
                        }
                        .overlay(
                            HStack {
                                Spacer()
                                if !longitude.isEmpty {
                                    Button {
                                        longitude = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 8)
                                }
                            }
                        )
                        .padding(.bottom, 10)

                    DatePicker("Birth Date", selection: $date, displayedComponents: .date)
                    DatePicker("Birth Time", selection: $time, displayedComponents: .hourAndMinute)
                }
                .padding()
                .cornerRadius(16)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.94)

                HStack {
                    Spacer()
                    Button("Cancel") {
                        dismiss()
                        isLatitudeFocused = false
                        isLongitudeFocused = false
                        isLatitudeFocusedInternal = false
                        isLongitudeFocusedInternal = false
                    }
                    .buttonStyle(.automatic)
                    Spacer()
                    Button("Delete") {
                        deleteEntry()
                        isLatitudeFocused = false
                        isLongitudeFocused = false
                        isLatitudeFocusedInternal = false
                        isLongitudeFocusedInternal = false
                    }
                    .buttonStyle(.automatic)
                    Spacer()
                    Button("Submit") {
                        saveBirthDate()
                    }
                    .buttonStyle(.automatic)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, (isLatitudeFocused || isLongitudeFocused) ? UIScreen.main.bounds.height / 3.5 + 10 : 10) // Dynamic bottom padding to accommodate the NumPad.
                .padding(.top)

                // Spacer to push content upwards when the custom keyboard is active.
                if isLatitudeFocused || isLongitudeFocused {
                    Spacer()
                }
            }
            .vstackStyle()
            .navigationTitle("Birth Data")
            .preferredColorScheme(.dark)

            // Custom NumPadView that appears when latitude field is focused.
            if isLatitudeFocused {
                VStack {
                    Spacer() // Pushes the NumPad to the bottom.
                    NumPadView(text: $latitude) // Binds the NumPad text to the latitude state.
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.3), value: isLatitudeFocused)
                }
                .zIndex(1) // Ensures the NumPad is above other elements.
            }
            // Custom NumPadView that appears when longitude field is focused and latitude is not.
            if isLongitudeFocused && !isLatitudeFocused {
                VStack {
                    Spacer() // Pushes the NumPad to the bottom.
                    NumPadView(text: $longitude) // Binds the NumPad text to the longitude state.
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.3), value: isLongitudeFocused)
                }
                .zIndex(1) // Ensures the NumPad is above other elements.
            }
        }
        .alert("Invalid Coordinates", isPresented: $showInvalidCoordinates) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter correct values. Latitude must be between -90 and 90 and Longitude between -180 and 180.")
        }
        .onAppear {
            if let entry = existingEntry {
                city = entry.city
                latitude = String(entry.latitude)
                longitude = String(entry.longitude)
                date = entry.date
                time = entry.time
            }
        }
    }

    func saveBirthDate() {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            showInvalidCoordinates = true
            return
        }
        guard abs(lat) <= 90, abs(lon) <= 180 else {
            showInvalidCoordinates = true
            return
        }

        if let entry = existingEntry {
            entry.city = city
            entry.latitude = lat
            entry.longitude = lon
            entry.date = date
            entry.time = time
        } else {
            let newEntry = BirthDate(city: city, latitude: lat, longitude: lon, date: date, time: time)
            modelContext.insert(newEntry)
        }
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving data: \(error)")
        }
    }

    func deleteEntry() {
        guard let entry = existingEntry else { return }
        modelContext.delete(entry)
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error deleting data: \(error)")
        }
    }
}

#Preview {
    let sample = BirthDate(city: "Berlin", latitude: 52.46, longitude: 13.42, date: .now, time: .now)
    return BirthDateView(existingEntry: sample)
}

