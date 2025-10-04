import SwiftUI
import PokemonDomain
import CoreKit

@MainActor
public final class GenerationDetailViewModel: ObservableObject {
    private let fetchPokemon: FetchPokemonForGenerationUseCase
    private let generation: Generation

    @Published public private(set) var state: LoadableState<[PokemonSummary]> = .idle

    public var title: String { generation.displayName }
    public var generationID: Int { generation.id }

    public init(generation: Generation, fetchPokemon: FetchPokemonForGenerationUseCase) {
        self.generation = generation
        self.fetchPokemon = fetchPokemon
    }

    public func load() async {
        guard !state.isLoading else { return }
        state = .loading
        do {
            let pokemon = try await fetchPokemon(generation.id)
            state = .loaded(pokemon.sorted(by: { $0.id < $1.id }))
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown)
        }
    }
}
