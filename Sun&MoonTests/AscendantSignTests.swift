import XCTest
@testable import Sun_Moon

final class AscendantSignTests: XCTestCase {
    private let ascendant = AscendantSign()

    func testJulianDateForJ2000Epoch() {
        let result = ascendant.julianDate(year: 2000, month: 1, day: 1, hour: 12, minute: 0, second: 0)

        XCTAssertEqual(result, 2451545.0, accuracy: 0.000001)
    }

    func testAngleNormalizationWrapsIntoFullCircle() {
        XCTAssertEqual(ascendant.normalizeAngle(-10), 350, accuracy: 0.000001)
        XCTAssertEqual(ascendant.normalizeAngle(370), 10, accuracy: 0.000001)
    }

    func testZodiacSignMapsThirtyDegreeSegments() {
        XCTAssertEqual(ascendant.zodiacSign(for: 0), localized("Aries ♈︎"))
        XCTAssertEqual(ascendant.zodiacSign(for: 30), localized("Taurus ♉︎"))
        XCTAssertEqual(ascendant.zodiacSign(for: 359.9), localized("Pisces ♓︎"))
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
}
