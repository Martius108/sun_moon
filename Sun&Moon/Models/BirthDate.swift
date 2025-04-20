//
//  BirthData.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 15.04.25.
//

import Foundation
import SwiftData

@Model
class BirthDate {
    
    var city: String
    var latitude: Double
    var longitude: Double
    var date: Date
    var time: Date
    
    init(city: String, latitude: Double, longitude: Double, date: Date, time: Date) {
        
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
        self.time = time
    }
}
