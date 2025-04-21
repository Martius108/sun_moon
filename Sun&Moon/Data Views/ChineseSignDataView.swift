//
//  ChineseSignDataView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 12.04.25.
//

import SwiftUI

// View holding chinese zodiac sign data for content view
struct ChineseSignDataView: View {
    
    let birthDates: [BirthDate]
    
    var body: some View {
        VStack {
            if let birthDate = birthDates.first {
                let chineseSign = ChineseSigns.from(date: birthDate.date)
                HStack {
                    Text(ChineseSigns.current())
                        .font(.system(size: 18))
                        .padding(.top, 2)
                        .padding(.bottom, 7)
                }
                HStack {
                    Text("Your Sign:")
                        .font(.system(size: 17))
                        .foregroundStyle(.blue)
                        .padding(.bottom, 2)
                    Text(chineseSign)
                        .padding(.bottom, 2)
                }
                .padding(.bottom, 5)
            } else {
                HStack {
                    Text(ChineseSigns.current())
                        .font(.system(size: 18))
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                }
                .padding(.bottom, 4)
            }
        }
    }
}

