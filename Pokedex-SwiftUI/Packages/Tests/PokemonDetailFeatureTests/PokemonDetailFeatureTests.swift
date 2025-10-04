import XCTest
import PokemonDomain
import CoreKit
@testable import PokemonDetailFeature

final class PokemonDetailFeatureTests: XCTestCase {
    func testToggleFavoriteUpdatesState() async {
        let repository = ToggleStubRepository()
        let viewModel = PokemonDetailViewModel(
            loadDetail: LoadPokemonDetailUseCase(repository: repository),
            toggleFavorite: ToggleFavoriteUseCase(repository: repository),
            checkFavoriteStatus: CheckFavoriteStatusUseCase(repository: repository)
        )

        await viewModel.load(identifier: "1")
        XCTAssertFalse(viewModel.isFavorite)
        await viewModel.toggleFavoriteState()
        XCTAssertTrue(viewModel.isFavorite)
    }
}

private final actor ToggleStubRepository: PokemonRepository {
    private var storedDetail: PokemonDetail = PokemonDetail(
        id: 1,
        name: "bulbasaur",
        imageURL: nil,
        height: 7,
        weight: 69,
        types: [PokemonDetail.PokemonType(name: "grass", slot: 1)],
        gameVersions: []
    )
    private var isFavoriteFlag = false

    func generations() async throws -> [Generation] { [] }
    func pokemonList(forGeneration id: Int) async throws -> [PokemonSummary] { [] }
    func pokemonDetail(identifier: String) async throws -> PokemonDetail { storedDetail }
    func toggleFavorite(detail: PokemonDetail) async throws -> Bool {
        isFavoriteFlag.toggle()
        return isFavoriteFlag
    }
    func favorites() async throws -> [PokemonDetail] { isFavoriteFlag ? [storedDetail] : [] }
    func isFavorite(id: Int) async throws -> Bool { isFavoriteFlag }
}
