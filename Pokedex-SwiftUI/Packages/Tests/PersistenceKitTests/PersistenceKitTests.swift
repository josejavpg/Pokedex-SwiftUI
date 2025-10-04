import XCTest
@testable import PersistenceKit

final class PersistenceKitTests: XCTestCase {
    func testRecordMapping() {
        let record = FavoritePokemonRecord(
            id: 1,
            name: "bulbasaur",
            imageURL: nil,
            height: 7,
            weight: 69,
            types: ["grass", "poison"],
            gameVersions: ["red", "blue"]
        )
        XCTAssertEqual(record.types.count, 2)
        XCTAssertEqual(record.gameVersions.first, "red")
    }
}
