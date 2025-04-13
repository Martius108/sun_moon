//
//  AscendantSign.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 12.04.25.
//

import Foundation
import CoreLocation

struct AscendantSign {
    
    // main func to return ascendant and debug information
    func calculateAscendantWithDebug(for location: CLLocation, date: Date) -> (String, String) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: date)
        
        guard let year = components.year,
              let month = components.month,
              let day = components.day,
              let hour = components.hour,
              let minute = components.minute,
              let second = components.second else {
            return ("Error while calculating date + time", "Ascendant not found")
        }
        
        // Julianisches Datum berechnen
        let jd = julianDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        
        // Berechnung der GMST (Greenwich Mean Sidereal Time)
        let gmst = greenwichMeanSiderealTime(julianDate: jd)
        
        // Berechnung der lokalen Sternzeit (LST) aus GMST
        let longitude = location.coordinate.longitude
        let lst = localSiderealTime(gmst: gmst, longitude: longitude)
        
        // Umrechnung von LST in hh:mm:ss Format
        let lstHours = Int(lst / 15)
        let lstMinutes = Int((lst / 15 - Double(lstHours)) * 60)
        let lstSeconds = Int((((lst / 15 - Double(lstHours)) * 60) - Double(lstMinutes)) * 60)
        
        let formattedLST = String(format: "%02d:%02d:%02d", lstHours, lstMinutes, lstSeconds)
        
        // Aszendentenwinkel berechnen
        var ascendantDegree = calculateAscendantAngle(latitude: location.coordinate.latitude, lst: lst, julianDate: jd)
        
        // Korrektur des Aszendentenwinkels um 180° (wie bei Astro-seek)
        ascendantDegree = (ascendantDegree + 180).truncatingRemainder(dividingBy: 360)
        
        // Bestimmen des Sternzeichens (Zodiac) mit dem korrigierten Grad
        let zodiacSign = zodiacSign(for: ascendantDegree)
        
        let debugOutput = """
        Location: \(location.coordinate.latitude), \(location.coordinate.longitude)
        UTC Date: \(date)
        JD: \(jd)
        GMST: \(gmst)
        LST: \(lst)
        LST im Format hh:mm:ss: \(formattedLST)
        Ascendant: \(zodiacSign) bei \(ascendantDegree)°
        """
        
        return (zodiacSign, debugOutput)
    }
    
    // julian date calculation
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
    
    // ascendant angle calculation
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
    
    // get zodiac sign from angle
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
