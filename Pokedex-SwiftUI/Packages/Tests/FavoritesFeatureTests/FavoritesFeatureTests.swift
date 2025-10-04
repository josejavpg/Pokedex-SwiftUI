import XCTest
import PokemonDomain
import CoreKit
@testable import FavoritesFeature

final class FavoritesFeatureTests: XCTestCase {
    func testLoadEmptyFavorites() async {
        let repository = StubRepository()
        let useCase = LoadFavoritesUseCase(repository: repository)
        let viewModel = await FavoritesViewModel(loadFavorites: useCase)
        await viewModel.load()
        if case let .loaded(favorites) = await viewModel.state {
            XCTAssertTrue(favorites.isEmpty)
        } else {
            XCTFail("Expected loaded state")
        }
    }
}

private final class StubRepository: PokemonRepository {
    func generations() async throws -> [Generation] { [] }
    func pokemonList(forGeneration id: Int) async throws -> [PokemonSummary] { [] }
    func pokemonDetail(identifier: String) async throws -> PokemonDetail { throw AppError.notFound }
    func toggleFavorite(detail: PokemonDetail) async throws -> Bool { false }
    func favorites() async throws -> [PokemonDetail] { [] }
    func isFavorite(id: Int) async throws -> Bool { false }
}
