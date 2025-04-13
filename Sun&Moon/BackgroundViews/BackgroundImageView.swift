//
//  BackgroundImageView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 13.04.25.
//

import SwiftUI

struct BackgroundImageView: View {
    
    // use dismiss to remove a view from a NavigationStack
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Change you background image here!")
    }
}

#Preview {
    BackgroundImageView()
}
