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
        
        // 2. Remove unnecessary whitespace around hyphens
        result = result.replacingOccurrences(of: "\\s*-\\s*", with: "-", options: .regularExpression)
        
        // 3. Ersetze mehrere Leerzeichen durch genau eines
        result = result.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        
        // 4. Split on spaces or hyphens and format each word
        let separators = CharacterSet(charactersIn: " -")
        let components = result.components(separatedBy: separators)
        
        let capitalizedComponents = components.map { word -> String in
            guard let first = word.first else { return "" }
            return first.uppercased() + word.dropFirst().lowercased()
        }
        
        // 5. Rebuild the original string with correctly formatted separators
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
                
                // Find the current word's range in the original string
                let word = components[componentIndex]
                if let wordRange = result.range(of: word, range: index..<result.endIndex) {
                    index = wordRange.upperBound
                } else {
                    // Advance one character if the word cannot be found
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


