import Foundation
import CoreKit

public protocol PokemonAPIClient {
    func fetchGenerations() async throws -> [GenerationSummaryDTO]
    func fetchPokemonList(forGeneration generationID: Int) async throws -> [PokemonSummaryDTO]
    func fetchPokemonDetail(identifier: String) async throws -> PokemonDetailDTO
}

public struct PokeAPIClientConfiguration: Sendable {
    public let baseURL: URL

    public init(baseURL: URL = URL(string: "https://pokeapi.co/api/v2")!) {
        self.baseURL = baseURL
    }
}

public final class URLSessionPokemonAPIClient: PokemonAPIClient {
    private let session: URLSession
    private let configuration: PokeAPIClientConfiguration
    private let decoder: JSONDecoder

    public init(
        session: URLSession = .shared,
        configuration: PokeAPIClientConfiguration = .init()
    ) {
        self.session = session
        self.configuration = configuration
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func fetchGenerations() async throws -> [GenerationSummaryDTO] {
        let list: NamedAPIResourceList = try await request(path: "generation")
        return list.results.compactMap(GenerationSummaryDTO.init(resource:))
    }

    public func fetchPokemonList(forGeneration generationID: Int) async throws -> [PokemonSummaryDTO] {
        let detail: GenerationDetailDTO = try await request(path: "generation/\(generationID)")
        return detail.pokemonSpecies.compactMap(PokemonSummaryDTO.init(resource:))
    }

    public func fetchPokemonDetail(identifier: String) async throws -> PokemonDetailDTO {
        try await request(path: "pokemon/\(identifier)")
    }

    private func request<Response: Decodable>(path: String) async throws -> Response {
        let endpoint = configuration.baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw AppError.network(underlying: URLError(.badServerResponse))
            }
            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw AppError.decoding(underlying: error)
            }
        } catch {
            if let appError = error as? AppError {
                throw appError
            }
            throw AppError.network(underlying: error)
        }
    }
}
