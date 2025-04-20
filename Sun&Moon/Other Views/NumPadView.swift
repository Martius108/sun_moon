//
//  NumPad.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 20.04.25.
//

import SwiftUI

// Custom NumPad View to allow minus for coordinates
struct NumPadView: View {
    @Binding var text: String // Binding to the text in the associated TextField

    let buttons = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "-"]
    ]

    var body: some View {
        VStack(spacing: 8) { // Vertical stack to arrange rows of buttons
            ForEach(buttons, id: \.self) { row in // Iterate through each row of buttons
                HStack(spacing: 8) { // Horizontal stack to arrange buttons in a row
                    ForEach(row, id: \.self) { buttonLabel in // Iterate through each button label in the row
                        Button {
                            self.text += buttonLabel // Append the button's label to the text binding
                        } label: {
                            Text(buttonLabel) // Display the button's label
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Make buttons fill available space
                                .font(.title2) // Set the font size
                                .foregroundColor(.white) // Set the text color to white
                                .background(Color(.lightGray)) // Set the button's background color
                                .cornerRadius(8) // Apply rounded corners to the button
                        }
                    }
                }
                .padding(.horizontal, 10) // Add horizontal padding to the row of buttons
            }
        }
        .padding(.top, 7) // Add padding at the top of the NumPad
        .padding(.bottom, 19) // Add padding at the bottom of the NumPad
        .frame(height: UIScreen.main.bounds.height / 3.5) // Set a fixed height for the NumPad
        .background(Color(.darkGray)) // Set the background color of the NumPad
    }
}

struct NumPadView_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        return NumPadView(text: $text)
            .previewLayout(.fixed(width: 300, height: 200)) // Set a fixed size for the preview
    }
}
