//
//  Illumination.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 30.03.25.
//

import Foundation
import CoreLocation

struct Illumination {
    
    let currentDate = Date()
    let calendar = Calendar.current
 
    // convert degrees to rad
    private func degToRad(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }

    // normalize angle
    private func normalizeAngle(_ angle: Double) -> Double {
        return angle.truncatingRemainder(dividingBy: 360.0)
    }

    // get julian date
    private func julianDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, timezoneOffset: Double) -> Double {
        let Y = (month <= 2) ? year - 1 : year
        let M = (month <= 2) ? month + 12 : month
        let A = floor(Double(Y) / 100)
        let B = 2 - A + floor(A / 4)
        let dayFraction = (Double(hour) + Double(minute) / 60.0 + Double(second) / 3600.0 - timezoneOffset) / 24.0
        
        return floor(365.25 * Double(Y + 4716)) + floor(30.6001 * Double(M + 1)) + Double(day) + B - 1524.5 + dayFraction
    }

    // calculate moon illumination
    private func moonIllumination(julianDate: Double) -> Double {
        let T = (julianDate - 2451545.0) / 36525.0
        
        // sun's mean anomaly (M)
        let M = normalizeAngle(357.52911 + 35999.05029 * T - 0.0001537 * T * T)
        
        // moon's mean anomaly (M')
        let Mm = normalizeAngle(134.9634 + 477198.8676 * T + 0.008997 * T * T)
        
        // moon's mean elongation (D)
        let D = normalizeAngle(297.8502 + 445267.1115 * T - 0.001630 * T * T)
        
        // compute phase angle correction
        let i = 180 - D
            - 6.289 * sin(degToRad(Mm))
            + 2.100 * sin(degToRad(M))
            - 1.274 * sin(degToRad(2 * D - Mm))
            - 0.658 * sin(degToRad(2 * D))
            - 0.214 * sin(degToRad(2 * Mm))
            - 0.110 * sin(degToRad(D))
        
        // compute fraction of moon illuminated and return illumination
        let illumination = (1 + cos(degToRad(i))) / 2
        return illumination
    }

    func getDateTime() -> DateComponents {
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        return components
    }
    
    func getCurrentIllumination() -> String {
        
        let timeZone = TimeZone.current
        let offsetSeconds = Double(timeZone.secondsFromGMT(for: currentDate))
        let offsetHours = offsetSeconds / 3600.0  // Handles DST correctly
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        if let year = components.year, let month = components.month, let day = components.day,
           let hour = components.hour, let minute = components.minute, let second = components.second {
                
            let jd = julianDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second, timezoneOffset: offsetHours)
            let illumination = moonIllumination(julianDate: jd) * 100
            
            return String(format: "%.f", illumination)
        }
        return NSLocalizedString("Error while calculating illumination", comment: "")
    }
}


