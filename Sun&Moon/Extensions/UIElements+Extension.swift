//
//  UIElements+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 17.04.25.
//

import SwiftUI

// MARK: - Text Modifiers

/// Custom modifier to apply a header text style with title2 font and bottom padding.
struct HeaderTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2) // Use title2 font style for headers
            .padding(.bottom, 1) // Apply minimal bottom padding for spacing
    }
}

extension View {
    /// A convenient method to apply the header text style to any view.
    func headerStyle() -> some View {
        self.modifier(HeaderTextStyle())
    }
}

/// Custom modifier for general text style (e.g., white text with 18pt font).
struct TextStyle1: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white) // Apply white text color
            .font(.system(size: 18)) // Set font size to 18 points
    }
}

extension View {
    /// A convenient method to apply the general text style to any view.
    func textStyle1() -> some View {
        self.modifier(TextStyle1())
    }
}

// MARK: - Button Modifier

/// Custom modifier for primary button style with padding, background color, and rounded corners.
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding() // Add padding around the button
            .frame(maxWidth: .infinity) // Make the button span the full width
            .background(Color.accentColor) // Use the accent color as the background
            .foregroundColor(.white) // Set the text color to white
            .cornerRadius(10) // Apply rounded corners
    }
}

extension View {
    /// A convenient method to apply the primary button style to any view.
    func primaryButton() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}

// MARK: - Image Modifier

/// Extension to apply a custom image style that scales and fills the available space.
extension Image {
    func imageStyle() -> some View {
        self
            .resizable() // Allow the image to resize
            .scaledToFill() // Scale the image to fill the available space
            .ignoresSafeArea(.all) // Ignore safe area insets for full-screen images
    }
}
