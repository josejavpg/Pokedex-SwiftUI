import Foundation
import CoreKit

public struct FetchGenerationsUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction() async throws -> [Generation] {
        try await repository.generations()
    }
}

public struct FetchPokemonForGenerationUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction(_ generationID: Int) async throws -> [PokemonSummary] {
        try await repository.pokemonList(forGeneration: generationID)
    }
}

public struct LoadPokemonDetailUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction(identifier: String) async throws -> PokemonDetail {
        try await repository.pokemonDetail(identifier: identifier)
    }
}

public struct ToggleFavoriteUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction(detail: PokemonDetail) async throws -> Bool {
        try await repository.toggleFavorite(detail: detail)
    }
}

public struct LoadFavoritesUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction() async throws -> [PokemonDetail] {
        try await repository.favorites()
    }
}

public struct CheckFavoriteStatusUseCase: Sendable {
    private let repository: PokemonRepository

    public init(repository: PokemonRepository) {
        self.repository = repository
    }

    public func callAsFunction(id: Int) async throws -> Bool {
        try await repository.isFavorite(id: id)
    }
}
