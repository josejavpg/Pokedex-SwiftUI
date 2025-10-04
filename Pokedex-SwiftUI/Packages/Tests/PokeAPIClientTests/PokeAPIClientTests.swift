import XCTest
@testable import PokeAPIClient

final class PokeAPIClientTests: XCTestCase {
    func testIdentifierExtraction() throws {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/25/")!
        let resource = NamedAPIResource(name: "pikachu", url: url)
        let dto = PokemonSummaryDTO(resource: resource)
        XCTAssertEqual(dto?.id, 25)
    }
}
