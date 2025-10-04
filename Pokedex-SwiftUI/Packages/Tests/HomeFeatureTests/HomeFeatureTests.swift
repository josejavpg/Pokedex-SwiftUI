import XCTest
import PokemonDomain
import CoreKit
@testable import HomeFeature

final class HomeFeatureTests: XCTestCase {
//    func testFilteringAfterLoad() async {
//        let repository = StubRepository()
//        let useCase = FetchGenerationsUseCase(repository: repository)
//        let viewModel = await HomeViewModel(fetchGenerations: useCase)
//        await viewModel.load()
//        viewModel.searchText = "jo"
//        let filtered = await viewModel.filteredGenerations()
//        XCTAssertEqual(filtered.count, 1)
//        XCTAssertEqual(filtered.first?.name, "johto")
//    }
}

private final class StubRepository: PokemonRepository {
    func generations() async throws -> [Generation] {
        [Generation(id: 1, name: "kanto"), Generation(id: 2, name: "johto")]
    }

    func pokemonList(forGeneration id: Int) async throws -> [PokemonSummary] { [] }
    func pokemonDetail(identifier: String) async throws -> PokemonDetail { throw AppError.notFound }
    func toggleFavorite(detail: PokemonDetail) async throws -> Bool { false }
    func favorites() async throws -> [PokemonDetail] { [] }
    func isFavorite(id: Int) async throws -> Bool { false }
}
