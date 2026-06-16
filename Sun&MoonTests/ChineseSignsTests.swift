import XCTest
@testable import Sun_Moon

final class ChineseSignsTests: XCTestCase {
    func testChineseNewYearDateLookupCoversKnownYear() {
        let date = ChineseSigns.chineseNewYearDate(for: 2026)

        XCTAssertEqual(dateString(date), "2026-02-17")
    }

    func testChineseNewYearDateLookupReturnsNilOutsideTable() {
        XCTAssertNil(ChineseSigns.chineseNewYearDate(for: 2051))
    }

    func testChineseZodiacUsesPreviousYearBeforeChineseNewYear() {
        XCTAssertEqual(
            ChineseSigns.from(date: makeDate(year: 2026, month: 2, day: 16)),
            ChineseSigns.chineseZodiacWithElement(for: 2025)
        )
        XCTAssertEqual(
            ChineseSigns.from(date: makeDate(year: 2026, month: 2, day: 17)),
            ChineseSigns.chineseZodiacWithElement(for: 2026)
        )
    }

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(identifier: "Europe/Berlin")
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return components.date!
    }

    private func dateString(_ date: Date?) -> String? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Europe/Berlin")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
