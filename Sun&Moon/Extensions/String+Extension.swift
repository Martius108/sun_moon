//
//  String+Extension.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 22.04.25.
//

import Foundation

extension String {
    
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func cleanedCityName() -> String {
        // 1. Trim outer 
        var result = self.trimmed()
        
        // 2. Entferne überflüssige Leerzeichen um Bindestriche
        result = result.replacingOccurrences(of: "\\s*-\\s*", with: "-", options: .regularExpression)
        
        // 3. Ersetze mehrere Leerzeichen durch genau eines
        result = result.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // 4. Teile anhand von Leerzeichen oder Bindestrichen und formatiere jedes Wort
        let separators = CharacterSet(charactersIn: " -")
        let components = result.components(separatedBy: separators)
        
        let capitalizedComponents = components.map { word -> String in
            guard let first = word.first else { return "" }
            return first.uppercased() + word.dropFirst().lowercased()
        }
        
        // 5. Baue den ursprünglichen String wieder mit korrekt formatierten Trennzeichen zusammen
        var formatted = ""
        var index = result.startIndex
        var componentIndex = 0
        
        while index < result.endIndex {
            let char = result[index]
            
            if char == " " || char == "-" {
                formatted.append(char)
                index = result.index(after: index)
            } else if componentIndex < capitalizedComponents.count {
                formatted.append(capitalizedComponents[componentIndex])
                
                // Finde die Range des aktuellen Wortes im Originalstring
                let word = components[componentIndex]
                if let wordRange = result.range(of: word, range: index..<result.endIndex) {
                    index = wordRange.upperBound
                } else {
                    // Falls das Wort nicht gefunden wird, gehe vorsichtshalber ein Zeichen weiter
                    index = result.index(after: index)
                }
                
                componentIndex += 1
            } else {
                // Sicherheit: Index nicht mehr vorhanden – brich ab
                break
            }
        }
        return formatted
    }
}



