//
//  Date+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 01.04.25.
//

import CoreLocation

// MARK: - Date Extensions for Various Formatting and Localizations

extension Date {
    
    // MARK: - Short Formats

    /// Returns the time formatted according to the system's short time style.
    /// This is typically used for displaying the time in a compact format, such as "3:45 PM".
    var shortTime: String {
        DateFormatter.shortTimeFormatter.string(from: self)
    }

    /// Returns the date formatted according to the system's short date style.
    /// This is typically used for displaying the date in a compact format, such as "01/01/2025".
    var shortDate: String {
        DateFormatter.shortDateFormatter.string(from: self)
    }

    // MARK: - Localized Date and Time Formatting

    /// Converts the date to a string in a localized format based on the provided timezone.
    /// The date is formatted in a medium style (e.g., "Jan 1, 2025") without the time.
    /// - Parameter timezone: The timezone to use for formatting the date.
    /// - Returns: A string representation of the date in the provided timezone.
    func localDate(for timezone: TimeZone) -> String {
        // Create a new date formatter for localizing the date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timezone
        
        return dateFormatter.string(from: self)
    }

    /// Converts the time to a string in a localized format based on the provided timezone.
    /// The time is formatted in a short style (e.g., "3:45 PM") without the date.
    /// - Parameter timezone: The timezone to use for formatting the time.
    /// - Returns: A string representation of the time in the provided timezone.
    func localTime(for timezone: TimeZone) -> String {
        // Create a new time formatter for localizing the time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timezone
        
        return dateFormatter.string(from: self)
    }

    // MARK: - Day and Month Extraction

    /// Returns the day, month, and weekday from the date.
    /// The weekday is returned as a string (e.g., "Monday").
    /// - Returns: A tuple containing the day (Int), month (Int), and weekday (String).
    func getDayMonth() -> (day: Int, month: Int, weekday: String) {
        let timezone: TimeZone = .current
        
        // Create a formatter to get the full weekday name.
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = timezone
        let weekday = formatter.string(from: self)
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        let components = calendar.dateComponents([.day, .month], from: self)
        
        // Extract the day and month from the date components.
        let day = components.day ?? 0
        let month = components.month ?? 0
        
        return (day, month, weekday)
    }
}

// MARK: - BirthDate Extension for Combined Date and Time

/// Extension to combine a birthdate and time into a single `Date` object.
extension BirthDate {
    var combinedDateTime: Date {
        let calendar = Calendar.current
        // Extract the date components (year, month, day) from the `date` property.
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.date)
        // Extract the time components (hour, minute) from the `time` property.
        let timeComponents = calendar.dateComponents([.hour, .minute], from: self.time)

        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute

        // Combine the date and time components into a single `Date` object.
        // If the combination fails, return the original `date`.
        return calendar.date(from: combinedComponents) ?? self.date
    }
}

// MARK: - Private DateFormatter Extensions for Reusability

/// Private extension to define reusable `DateFormatter` instances for short date and time formats.
private extension DateFormatter {
    // DateFormatter for formatting short time (e.g., "3:45 PM").
    static let shortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()
    
    // DateFormatter for formatting short date (e.g., "01/01/2025").
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}



