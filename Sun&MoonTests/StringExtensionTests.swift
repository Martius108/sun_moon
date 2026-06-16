import XCTest
@testable import Sun_Moon

final class StringExtensionTests: XCTestCase {
    func testCleanedCityNameNormalizesWhitespaceHyphensAndCapitalization() {
        XCTAssertEqual("  new   york - city  ".cleanedCityName(), "New York-City")
        XCTAssertEqual("berlin".cleanedCityName(), "Berlin")
        XCTAssertEqual("bad   reichenhall".cleanedCityName(), "Bad Reichenhall")
    }
}
