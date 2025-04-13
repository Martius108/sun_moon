//
//  BirthDateView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 13.04.25.
//

import SwiftUI

struct BirthDateView: View {
    
    // use dismiss to remove a view from a NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Please put in your birth date, time and birth location")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            VStack(spacing: 20) {
                Text("Your Birth date")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                HStack {
                    Spacer()
                    DatePicker(" Select a date:", selection: .constant(Date()))
                        .foregroundStyle(.black)
                    Spacer()
                }
                .padding(.bottom, 10)
            }
            .frame(maxWidth: 0.94 * UIScreen.main.bounds.width)
            .padding(.vertical, 10)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
            .padding(10)
                
            VStack(spacing: 20) {
                Text("Your Location")
                    .font(.headline)
                
                HStack {
                    Spacer()
                    TextField(" City Name", text: .constant(""))
                        .foregroundStyle(.black)
                        .background(Color.white.opacity(0.3))
                    Spacer()
                    TextField(" Latitude", text: .constant(""))
                        .foregroundStyle(.black)
                        .background(Color.white.opacity(0.3))
                    TextField(" Longitude", text: .constant(""))
                        .foregroundStyle(.black)
                        .background(Color.white.opacity(0.3))
                    Spacer()
                }
                .padding(.bottom, 10)
                
            }
            .frame(maxWidth: 0.94 * UIScreen.main.bounds.width)
            .padding(.vertical, 10)
            .background(.regularMaterial)
            .clipShape(.rect(cornerRadius: 20))
            .padding(10)
            
            HStack  {
                Button(action: {
                    dismiss()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
                .padding(.top, 10)
            }
        }
        .background {
            Image(.image1)
        }
    }
}

#Preview {
    BirthDateView()
}
