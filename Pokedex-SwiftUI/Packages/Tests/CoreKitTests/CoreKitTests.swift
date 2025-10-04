import XCTest
@testable import CoreKit

final class CoreKitTests: XCTestCase {
    func testLoadableStateValue() {
        let state: LoadableState<Int> = .loaded(42)
        XCTAssertEqual(state.value, 42)
    }
}
