//
//  Vstack+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 17.04.25.
//

import SwiftUI

// MARK: - ViewModifier for VStack
// A custom ViewModifier to style a VStack with a specific layout
struct VStackStyle: ViewModifier {
    func body(content: Content) -> some View {
        // Apply several style modifications to the VStack
        content
            // Set the maximum width of the VStack to 95% of the screen width
            .frame(maxWidth: 0.95 * UIScreen.main.bounds.width)
            // Apply vertical padding for spacing between elements
            .padding(.vertical, 7)
            // Set a regular material background style (blurred effect)
            .background(.regularMaterial)
            // Force the color scheme to light mode
            .environment(\.colorScheme, .light)
            // Clip the corners of the VStack to give it rounded edges
            .clipShape(.rect(cornerRadius: 20))
            // Add padding around the VStack
            .padding(8)
    }
}

// MARK: - Extension for VStack
// A convenience method to easily apply the custom VStackStyle to any view
extension View {
    func vstackStyle() -> some View {
        self.modifier(VStackStyle()) // Apply the VStackStyle modifier
    }
}

