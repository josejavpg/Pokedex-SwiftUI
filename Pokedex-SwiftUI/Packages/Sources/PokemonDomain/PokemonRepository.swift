import Foundation
import CoreKit

public protocol PokemonRepository: Sendable {
    func generations() async throws -> [Generation]
    func pokemonList(forGeneration id: Int) async throws -> [PokemonSummary]
    func pokemonDetail(identifier: String) async throws -> PokemonDetail
    func toggleFavorite(detail: PokemonDetail) async throws -> Bool
    func favorites() async throws -> [PokemonDetail]
    func isFavorite(id: Int) async throws -> Bool
}

public extension PokemonRepository {
    func pokemonDetail(id: Int) async throws -> PokemonDetail {
        try await pokemonDetail(identifier: String(id))
    }
}
