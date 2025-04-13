//
//  Date+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 01.04.25.
//

import Foundation

extension Date {
    
    // converts date to local settings
    func localDate(for timezone: TimeZone) -> String {
        // create a new date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timezone
        
        return dateFormatter.string(from: self)
    }
    // converts time to local settings
    func localTime(for timezone: TimeZone) -> String {
        // create a new time formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timezone
        
        return dateFormatter.string(from: self)
    }
    
    func getDayMonth() -> (currentDay: Int, currentMonth: Int, currentWeekDay: String) {
        // current date
        let now = Date()
        let timezone: TimeZone = .current
        
        // get weekday
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = timezone
        let currentWeekDay = formatter.string(from: now)
        
        // use calendar with your timezone
        var calendar = Calendar.current
        calendar.timeZone = timezone

        // Extract day and month components
        let components = calendar.dateComponents([.day, .month], from: now)
        let currentDay: Int = components.day ?? 0
        let currentMonth: Int = components.month ?? 0
        
        return (currentDay, currentMonth, currentWeekDay)
    }
}
