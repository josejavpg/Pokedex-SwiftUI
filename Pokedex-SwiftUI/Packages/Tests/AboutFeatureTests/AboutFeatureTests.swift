import XCTest
@testable import AboutFeature

final class AboutFeatureTests: XCTestCase {
    func testAboutViewInitialization() {
        let view = AboutView()
        XCTAssertNotNil(view)
    }
}
