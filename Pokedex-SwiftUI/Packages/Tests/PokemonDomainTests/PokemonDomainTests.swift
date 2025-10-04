import XCTest
@testable import PokemonDomain

final class PokemonDomainTests: XCTestCase {
    func testPokemonDetailFormatting() {
        let detail = PokemonDetail(
            id: 1,
            name: "bulbasaur",
            imageURL: nil,
            height: 7,
            weight: 69,
            types: [PokemonDetail.PokemonType(name: "grass", slot: 1)],
            gameVersions: []
        )
        XCTAssertEqual(detail.formattedHeight, "0.7 m")
        XCTAssertEqual(detail.formattedWeight, "6.9 kg")
    }
}
