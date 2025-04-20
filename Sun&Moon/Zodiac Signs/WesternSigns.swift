//
//  Westernnames.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 06.04.25.
//

import Foundation

class WesternSigns {
    
    var name: String = ""
    var element: String = ""
    var day: Int = 0
    var month: Int = 0
    var symbol: String = ""
    
    // Creates name, element and symbol for the zodiac signs from date
    func getName(day: Int, month: Int) -> (name: String, element: String, symbol: String) {
        
        if (month == 1 && day <= 20) { // Capricorn 22.12.-20.1.
            name = NSLocalizedString("Capricorn", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♑︎"
        }
        if (month == 1 && day >= 21) { // Wassermann 21.1.-19.2
            name = NSLocalizedString("Aquarius", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♒︎"
        }
        if (month == 2 && day <= 19) {
            name = NSLocalizedString("Aquarius", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♒︎"
        }
        if (month == 2 && day >= 20) { // Fische 20.2.-20.3.
            name = NSLocalizedString("Pisces", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♓︎"
        }
        if (month == 3 && day <= 20) {
            name = NSLocalizedString("Pisces", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♓︎"
        }
        if (month == 3 && day >= 21) { // Widder 21.3.-20.4.
            name = NSLocalizedString("Aries", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♈︎"
        }
        if (month == 4 && day <= 20) {
            name = NSLocalizedString("Aries", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♈︎"
        }
        if (month == 4 && day >= 21) { // Stier 21.4.-20.5.
            name = NSLocalizedString("Taurus", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♉︎"
        }
        if (month == 5 && day <= 20) {
            name = NSLocalizedString("Taurus", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♉︎"
        }
        if (month == 5 && day >= 21) { // Zwillinge 21.5.-21.6.
            name = NSLocalizedString("Gemini", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♊︎"
        }
        if (month == 6 && day <= 21) {
            name = NSLocalizedString("Gemini", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♊︎"
        }
        if (month == 6 && day >= 22) { // Krebs 22.6.-22.7.
            name = NSLocalizedString("Cancer", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♋︎"
        }
        if (month == 7 && day <= 22) {
            name = NSLocalizedString("Cancer", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♋︎"
        }
        if (month == 7 && day >= 23) { // Löwe 23.7.-23.8.
            name = NSLocalizedString("Leo", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♌︎"
        }
        if (month == 8 && day <= 23) {
            name = NSLocalizedString("Leo", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♌︎"
        }
        if (month == 8 && day >= 24) { // Jungfrau 24.8.-23.9.
            name = NSLocalizedString("Virgo", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♍︎"
        }
        if (month == 9 && day <= 23) {
            name = NSLocalizedString("Virgo", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♍︎"
        }
        if (month == 9 && day >= 24) { // Waage 24.9.-23.10.
            name = NSLocalizedString("Libra", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♎︎"
        }
        if (month == 10 && day <= 23) {
            name = NSLocalizedString("Libra", comment: "")
            element = NSLocalizedString("Air", comment: "")
            symbol = "♎︎"
        }
        if (month == 10 && day >= 24) { // Skorpion 24.10.-22.11.
            name = NSLocalizedString("Scorpio", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♏︎"
        }
        if (month == 11 && day <= 22) {
            name = NSLocalizedString("Scorpio", comment: "")
            element = NSLocalizedString("Water", comment: "")
            symbol = "♏︎"
        }
        if (month == 11 && day >= 23) { // Schütze 23.11.-21.12.
            name = NSLocalizedString("Sagittarius", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♐︎"
        }
        if (month == 12 && day <= 21) {
            name = NSLocalizedString("Sagittarius", comment: "")
            element = NSLocalizedString("Fire", comment: "")
            symbol = "♐︎"
        }
        if (month == 12 && day >= 22) { // Steinbock 22.12.-20.1.
            name = NSLocalizedString("Capricorn", comment: "")
            element = NSLocalizedString("Earth", comment: "")
            symbol = "♑︎"
        }
        return (name, element, symbol)
    }
}
