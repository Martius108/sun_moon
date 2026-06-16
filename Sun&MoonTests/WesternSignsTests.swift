import XCTest
@testable import Sun_Moon

final class WesternSignsTests: XCTestCase {
    func testBoundaryDatesReturnExpectedSigns() {
        let cases: [(day: Int, month: Int, name: String, element: String)] = [
            (20, 1, localized("Capricorn"), localized("Earth")),
            (21, 1, localized("Aquarius"), localized("Air")),
            (19, 2, localized("Aquarius"), localized("Air")),
            (20, 2, localized("Pisces"), localized("Water")),
            (20, 3, localized("Pisces"), localized("Water")),
            (21, 3, localized("Aries"), localized("Fire")),
            (22, 12, localized("Capricorn"), localized("Earth"))
        ]

        let signs = WesternSigns()

        for testCase in cases {
            let result = signs.getName(day: testCase.day, month: testCase.month)
            XCTAssertEqual(result.name, testCase.name, "Unexpected sign for \(testCase.day).\(testCase.month)")
            XCTAssertEqual(result.element, testCase.element, "Unexpected element for \(testCase.day).\(testCase.month)")
            XCTAssertFalse(result.symbol.isEmpty)
        }
    }

    private func localized(_ key: String) -> String {
        NSLocalizedString(key, bundle: Bundle.main, comment: "")
    }
}
