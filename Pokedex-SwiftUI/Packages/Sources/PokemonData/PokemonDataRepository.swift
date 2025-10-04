import Foundation
import CoreKit
import PokeAPIClient
import PersistenceKit
import PokemonDomain

public final class PokemonDataRepository: PokemonRepository {
    private let apiClient: PokemonAPIClient
    private let favoritesStore: FavoritesStore

    public init(apiClient: PokemonAPIClient, favoritesStore: FavoritesStore) {
        self.apiClient = apiClient
        self.favoritesStore = favoritesStore
    }

    public func generations() async throws -> [Generation] {
        let dtos = try await apiClient.fetchGenerations()
        return dtos.map { Generation(id: $0.id, name: $0.name) }
    }

    public func pokemonList(forGeneration id: Int) async throws -> [PokemonSummary] {
        let dtos = try await apiClient.fetchPokemonList(forGeneration: id)
        return dtos.map { PokemonSummary(id: $0.id, name: $0.name) }
    }

    public func pokemonDetail(identifier: String) async throws -> PokemonDetail {
        if let id = Int(identifier), let cached = try await loadFavorite(id: id) {
            return cached
        }

        let dto = try await apiClient.fetchPokemonDetail(identifier: identifier)
        return dto.toDomain()
    }

    public func toggleFavorite(detail: PokemonDetail) async throws -> Bool {
        if try await isFavorite(id: detail.id) {
            try await removeFavorite(id: detail.id)
            return false
        } else {
            try await saveFavorite(detail: detail)
            return true
        }
    }

    public func favorites() async throws -> [PokemonDetail] {
        try await MainActor.run {
            let entities = try favoritesStore.fetchFavorites()
            return entities.map { $0.toDomain() }
        }
    }

    public func isFavorite(id: Int) async throws -> Bool {
        try await MainActor.run {
            try favoritesStore.favorite(withID: id) != nil
        }
    }

    private func loadFavorite(id: Int) async throws -> PokemonDetail? {
        try await MainActor.run {
            try favoritesStore.favorite(withID: id)?.toDomain()
        }
    }

    private func saveFavorite(detail: PokemonDetail) async throws {
        let record = FavoritePokemonRecord(
            id: detail.id,
            name: detail.name,
            imageURL: detail.imageURL,
            height: detail.height,
            weight: detail.weight,
            types: detail.types.map(\.name),
            gameVersions: detail.gameVersions.map(\.name)
        )
        try await MainActor.run {
            try favoritesStore.save(record: record)
        }
    }

    private func removeFavorite(id: Int) async throws {
        try await MainActor.run {
            try favoritesStore.removeFavorite(withID: id)
        }
    }
}

private extension FavoritePokemonEntity {
    func toDomain() -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: name,
            imageURL: imageURL,
            height: height,
            weight: weight,
            types: types.enumerated().map { index, typeName in
                PokemonDetail.PokemonType(name: typeName, slot: index + 1)
            },
            gameVersions: gameVersions.map { PokemonDetail.GameVersion(name: $0) }
        )
    }
}

private extension PokemonDetailDTO {
    func toDomain() -> PokemonDetail {
        PokemonDetail(
            id: id,
            name: name,
            imageURL: sprites.other?.officialArtwork?.frontDefault ?? sprites.frontDefault,
            height: height,
            weight: weight,
            types: types.map { entry in
                PokemonDetail.PokemonType(name: entry.type.name, slot: entry.slot)
            },
            gameVersions: gameIndices.map { PokemonDetail.GameVersion(name: $0.version.name) }
        )
    }
}
