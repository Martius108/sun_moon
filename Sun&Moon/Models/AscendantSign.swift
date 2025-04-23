//
//  AscendantSign.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 12.04.25.
//

import Foundation
import CoreLocation

// Sruct to calculate ascendant sign
struct AscendantSign {
    
    // Main func to return ascendant
    func calculateAscendantSign(for location: CLLocation, date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else {
            return (NSLocalizedString("Error while calculating ascendant sign", comment: ""))
        }
        
        // Get julian date for zodiac sign calculation
        let jd = julianDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        
        // Get Greenwich Mean Sidereal Time
        let gmst = greenwichMeanSiderealTime(julianDate: jd)
        
        // Get Local Sidereal Time from GMST
        let longitude = location.coordinate.longitude
        let lst = localSiderealTime(gmst: gmst, longitude: longitude)
        
        // Get ascendant angle
        var ascendantDegree = calculateAscendantAngle(latitude: location.coordinate.latitude, lst: lst, julianDate: jd)
        
        // Correction of ascendant angle
        ascendantDegree = (ascendantDegree + 180).truncatingRemainder(dividingBy: 360)
        
        // get zodiac sign from angle
        let zodiacSign = zodiacSign(for: ascendantDegree)
        return (zodiacSign)
    }
    
    // Julian date calculation
    func julianDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Double {
        var y = year
        var m = month
        if m <= 2 {
            y -= 1
            m += 12
        }
        
        let A = floor(Double(y) / 100.0)
        let B = 2 - A + floor(A / 4.0)
        
        let dayFraction = (Double(hour) + Double(minute) / 60.0 + Double(second) / 3600.0) / 24.0
        return floor(365.25 * Double(y + 4716)) + floor(30.6001 * Double(m + 1)) + Double(day) + B - 1524.5 + dayFraction
    }
    
    // GMST calculation
    func greenwichMeanSiderealTime(julianDate: Double) -> Double {
        let T = (julianDate - 2451545.0) / 36525.0
        var GMST = 280.46061837 + 360.98564736629 * (julianDate - 2451545.0) + 0.000387933 * T * T - T * T * T / 38710000.0
        GMST = fmod(GMST, 360.0)
        if GMST < 0 { GMST += 360.0 }
        return GMST
    }
    
    // LST calculation
    func localSiderealTime(gmst: Double, longitude: Double) -> Double {
        // GMST ist in Grad (0 - 360), wir müssen diese umrechnen, um LST zu erhalten.
        var LST = gmst + longitude
        if LST < 0 { LST += 360.0 }
        if LST >= 360.0 { LST -= 360.0 }
        return LST
    }
    
    // Ascendant angle calculation
    func calculateAscendantAngle(latitude: Double, lst: Double, julianDate: Double) -> Double {
        let T = (julianDate - 2451545.0) / 36525.0
        let epsilon = degToRad(23.439291 - 0.0130042 * T)
        
        let latRad = degToRad(latitude)
        let lstRad = degToRad(lst)
        
        let numerator = -cos(lstRad)
        let denominator = sin(lstRad) * cos(epsilon) + tan(latRad) * sin(epsilon)
        
        let ascRad = atan2(numerator, denominator)
        return normalizeAngle(radToDeg(ascRad))
    }
    
    // Get zodiac sign from angle
    func zodiacSign(for degree: Double) -> String {
        let signs = [
            NSLocalizedString("Aries ♈︎", comment: ""), NSLocalizedString("Taurus ♉︎", comment: ""), NSLocalizedString("Gemini ♊︎", comment: ""), NSLocalizedString("Cancer ♋︎", comment: ""),
            NSLocalizedString("Leo ♌︎", comment: ""), NSLocalizedString("Virgo ♍︎", comment: ""), NSLocalizedString("Libra ♎︎", comment: ""), NSLocalizedString("Scorpio ♏︎", comment: ""),
            NSLocalizedString("Sagittarius ♐︎", comment: ""), NSLocalizedString("Capricorn ♑︎", comment: ""), NSLocalizedString("Aquarius ♒︎", comment: ""),
            NSLocalizedString("Pisces ♓︎", comment: "")
        ]
        let index = Int(degree / 30.0) % 12
        return signs[index]
    }
    
    func degToRad(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    func radToDeg(_ radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
    func normalizeAngle(_ angle: Double) -> Double {
        var result = angle.truncatingRemainder(dividingBy: 360.0)
        if result < 0 { result += 360.0 }
        return result
    }
}
