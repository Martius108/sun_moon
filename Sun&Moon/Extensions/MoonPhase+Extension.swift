//
//  String+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 05.04.25.
//

import Foundation

// MARK: - Enum for Moon Phases

/// Enum representing the different phases of the moon.
enum MoonPhase: String, Codable {
    case new // New Moon
    case waxingCrescent // Waxing Crescent Moon
    case firstQuarter // First Quarter Moon
    case waxingGibbous // Waxing Gibbous Moon
    case full // Full Moon
    case waningGibbous // Waning Gibbous Moon
    case lastQuarter // Last Quarter Moon
    case waningCrescent // Waning Crescent Moon
}

// MARK: - MoonPhase Localization Extension

/// Extension to MoonPhase enum for localization handling.
extension MoonPhase {
    
    /// Returns the localization key for the moon phase.
    /// The key follows the pattern "moon_phase.<rawValue>" for easy localization lookup.
    var localizationKey: String {
        "moon_phase.\(self.rawValue)"
    }
    
    /// Retrieves the localized string for the current moon phase using the localization key.
    /// This allows for easy internationalization of moon phase names.
    var localizedString: String {
        NSLocalizedString(self.localizationKey, comment: "")
    }
}

