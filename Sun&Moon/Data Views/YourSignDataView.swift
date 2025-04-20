//
//  YourZodiacSign.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 19.04.25.
//

import SwiftUI
import SwiftData
import CoreLocation

struct YourSignDataView: View {
    
    let birthDate: BirthDate
    let westernSignName = WesternSigns()
    let ascendantSign = AscendantSign()
    
    private var day: Int {
        Calendar.current.component(.day, from: birthDate.date)
    }
    private var month: Int {
        Calendar.current.component(.month, from: birthDate.date)
    }
    private var birthLocation: CLLocation {
        CLLocation(latitude: birthDate.latitude, longitude: birthDate.longitude)
    }
    
    var body: some View {
        
        HStack {
            let (name, _, _) = westernSignName.getName(day: day, month: month)
            Text("Your Sign:")
                .font(.system(size: 17))
                .foregroundStyle(.blue)
            Text("\(name),")
                .font(.system(size: 17))
            let ascendantSign = getCurrentAscendentZodiacSign(location: birthLocation)
            Text("Asc.")
                Text(ascendantSign)
                    .font(.system(size: 17))
        }
        .padding(.bottom, 2)
    }
    
    func getCurrentAscendentZodiacSign(location: CLLocation) -> String {
        let (zodiacSign) = ascendantSign.calculateAscendantWithDebug(for: birthLocation, date: birthDate.combinedDateTime)
        return zodiacSign
    }
}
