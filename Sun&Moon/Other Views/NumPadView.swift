//
//  NumPad.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 20.04.25.
//

import SwiftUI

// Custom NumPad to allow minus for coordinates
struct NumPadView: View {
    @Binding var text: String

    let buttons = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "-"]
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { buttonLabel in
                        Button {
                            self.text += buttonLabel
                        } label: {
                            Text(buttonLabel)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.title2)
                                .foregroundColor(.white)
                                .background(Color(.lightGray))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 10) 
            }
        }
        .padding(.top, 7)
        .padding(.bottom, 19)
        .frame(height: UIScreen.main.bounds.height / 3.5)
        .background(Color(.darkGray))
    }
}

struct NumPadView_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        return NumPadView(text: $text)
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
