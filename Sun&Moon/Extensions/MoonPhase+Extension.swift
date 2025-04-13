//
//  String+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 05.04.25.
//

import Foundation

enum MoonPhase: String, Codable {
    case new
    case waxingCrescent
    case firstQuarter
    case waxingGibbous
    case full
    case waningGibbous
    case lastQuarter
    case waningCrescent
}

extension MoonPhase {
    
    var localizationKey: String {
        "moon_phase.\(self.rawValue)"
    }
    var localizedString: String {
        NSLocalizedString(self.localizationKey, comment: "")
    }
}
