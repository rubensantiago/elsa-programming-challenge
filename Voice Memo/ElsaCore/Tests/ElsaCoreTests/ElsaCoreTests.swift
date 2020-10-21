import XCTest
@testable import ElsaCore

final class ElsaCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ElsaCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
