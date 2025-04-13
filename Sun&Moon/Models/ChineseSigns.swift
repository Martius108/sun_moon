//
//  ChineseSign.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 10.04.25.
//

import Foundation

struct ChineseSigns {
    
    static func chineseNewYearDate(for year: Int) -> Date? {
        let chineseNewYears: [Int: String] = [
            1961: "1961-02-15", 1962: "1962-02-05", 1963: "1963-01-25",
            1964: "1964-02-13", 1965: "1965-02-02", 1966: "1966-01-21",
            1967: "1967-02-09", 1968: "1968-01-30", 1969: "1969-02-17",
            1970: "1970-02-06", 1971: "1971-01-27", 1972: "1972-02-15",
            1973: "1973-02-03", 1974: "1974-01-23", 1975: "1975-02-11",
            1976: "1976-01-31", 1977: "1977-02-18", 1978: "1978-02-07",
            1979: "1979-01-28", 1980: "1980-02-16", 1981: "1981-02-05",
            1982: "1982-01-25", 1983: "1983-02-13", 1984: "1984-02-02",
            1985: "1985-02-20", 1986: "1986-02-09", 1987: "1987-01-29",
            1988: "1988-02-17", 1989: "1989-02-06", 1990: "1990-01-27",
            1991: "1991-02-15", 1992: "1992-02-04", 1993: "1993-01-23",
            1994: "1994-02-10", 1995: "1995-01-31", 1996: "1996-02-19",
            1997: "1997-02-07", 1998: "1998-01-28", 1999: "1999-02-16",
            2000: "2000-02-05", 2001: "2001-01-24", 2002: "2002-02-12",
            2003: "2003-02-01", 2004: "2004-01-22", 2005: "2005-02-09",
            2006: "2006-01-29", 2007: "2007-02-18", 2008: "2008-02-07",
            2009: "2009-01-26", 2010: "2010-02-14", 2011: "2011-02-03",
            2012: "2012-01-23", 2013: "2013-02-10", 2014: "2014-01-31",
            2015: "2015-02-19", 2016: "2016-02-08", 2017: "2017-01-28",
            2018: "2018-02-16", 2019: "2019-02-05", 2020: "2020-01-25",
            2021: "2021-02-12", 2022: "2022-02-01", 2023: "2023-01-22",
            2024: "2024-02-10", 2025: "2025-01-29", 2026: "2026-02-17",
            2027: "2027-02-06", 2028: "2028-01-26", 2029: "2029-02-13",
            2030: "2030-02-03", 2031: "2031-01-23", 2032: "2032-02-11",
            2033: "2033-01-31", 2034: "2034-02-19", 2035: "2035-02-08",
            2036: "2036-01-28", 2037: "2037-02-15", 2038: "2038-02-04",
            2039: "2039-01-24", 2040: "2040-02-12", 2041: "2041-02-01",
            2042: "2042-01-22", 2043: "2043-02-10", 2044: "2044-01-30",
            2045: "2045-02-17", 2046: "2046-02-06", 2047: "2047-01-26",
            2048: "2048-02-14", 2049: "2049-02-02", 2050: "2050-01-23"
        ]
        
        guard let dateString = chineseNewYears[year] else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        return formatter.date(from: dateString)
    }
    
    static func chineseZodiacWithElement(for year: Int) -> String {
        let zodiacAnimals = [
            NSLocalizedString("Rat 🐀", comment: ""), NSLocalizedString("Ox 🐂", comment: ""),
            NSLocalizedString("Tiger 🐅", comment: ""), NSLocalizedString("Rabbit 🐇", comment: ""),
            NSLocalizedString("Dragon 🐉", comment: ""), NSLocalizedString("Snake 🐍", comment: ""),
            NSLocalizedString("Horse 🐎", comment: ""), NSLocalizedString("Goat 🐐", comment: ""),
            NSLocalizedString("Monkey 🐒", comment: ""), NSLocalizedString("Rooster 🐓", comment: ""),
            NSLocalizedString("Dog 🐕", comment: ""), NSLocalizedString("Pig 🐖", comment: "")
        ]
        
        let elements = [
            NSLocalizedString("Wood", comment: ""), NSLocalizedString("Wood", comment: ""),
            NSLocalizedString("Fire", comment: ""), NSLocalizedString("Fire", comment: ""),
            NSLocalizedString("Earth", comment: ""), NSLocalizedString("Earth", comment: ""),
            NSLocalizedString("Metal", comment: ""), NSLocalizedString("Metal", comment: ""),
            NSLocalizedString("Water", comment: ""), NSLocalizedString("Water", comment: "")
        ]
        
        let baseYear = 1984
        let stemBranchIndex = (year - baseYear) % 60
        let correctedIndex = stemBranchIndex >= 0 ? stemBranchIndex : (stemBranchIndex + 60)
        
        let elementIndex = correctedIndex % 10
        let animalIndex = correctedIndex % 12
        
        return "\(elements[elementIndex]) \(zodiacAnimals[animalIndex])"
    }
    
    static func from(date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        
        guard let chineseNewYear = chineseNewYearDate(for: year) else {
            return "No new year date found"
        }
        
        let zodiacYear = date < chineseNewYear ? year - 1 : year
        return chineseZodiacWithElement(for: zodiacYear)
    }
    
    static func current() -> String {
        return from(date: Date())
    }
}
