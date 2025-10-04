import XCTest
@testable import PokemonData
import PokeAPIClient
import PokemonDomain
import PersistenceKit

final class PokemonDataRepositoryTests: XCTestCase {
    func testFavoriteTogglePersists() async throws {
        let apiClient = StubAPIClient()
        let store = await InMemoryFavoritesStore()
        let repository = PokemonDataRepository(apiClient: apiClient, favoritesStore: store)
        let detail = try await repository.pokemonDetail(identifier: "25")
        let added = try await repository.toggleFavorite(detail: detail)
        XCTAssertTrue(added)

        let isFavorite = try await repository.isFavorite(id: detail.id)
        XCTAssertTrue(isFavorite)

        let removed = try await repository.toggleFavorite(detail: detail)
        XCTAssertFalse(removed)
    }
}

private final class StubAPIClient: PokemonAPIClient {
    func fetchGenerations() async throws -> [GenerationSummaryDTO] {
        []
    }

    func fetchPokemonList(forGeneration generationID: Int) async throws -> [PokemonSummaryDTO] {
        []
    }

    func fetchPokemonDetail(identifier: String) async throws -> PokemonDetailDTO {
        let id = Int(identifier) ?? 0
        let json = """
        {
          "id": \(id),
          "name": "pikachu",
          "height": 4,
          "weight": 60,
          "types": [
            {
              "slot": 1,
              "type": {
                "name": "electric",
                "url": "https://pokeapi.co/api/v2/type/13/"
              }
            }
          ],
          "game_indices": [],
          "sprites": {
            "front_default": null,
            "other": {
              "official-artwork": {
                "front_default": null
              }
            }
          }
        }
        """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(PokemonDetailDTO.self, from: data)
    }
}

@MainActor
private final class InMemoryFavoritesStore: FavoritesStore {
    private var storage: [Int: FavoritePokemonRecord] = [:]

    func fetchFavorites() throws -> [FavoritePokemonEntity] {
        storage.values.map { record in
            FavoritePokemonEntity(
                id: record.id,
                name: record.name,
                imageURL: record.imageURL,
                height: record.height,
                weight: record.weight,
                types: record.types,
                gameVersions: record.gameVersions
            )
        }
    }

    func favorite(withID id: Int) throws -> FavoritePokemonEntity? {
        guard let record = storage[id] else { return nil }
        return FavoritePokemonEntity(
            id: record.id,
            name: record.name,
            imageURL: record.imageURL,
            height: record.height,
            weight: record.weight,
            types: record.types,
            gameVersions: record.gameVersions
        )
    }

    func save(record: FavoritePokemonRecord) throws {
        storage[record.id] = record
    }

    func removeFavorite(withID id: Int) throws {
        storage.removeValue(forKey: id)
    }
}
