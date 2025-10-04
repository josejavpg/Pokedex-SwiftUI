import SwiftUI
import PokemonDomain
import CoreKit

@MainActor
public final class HomeViewModel: ObservableObject {
    private let fetchGenerations: FetchGenerationsUseCase

    @Published public private(set) var state: LoadableState<[Generation]> = .idle
    @Published public var searchText: String = ""

    public init(fetchGenerations: FetchGenerationsUseCase) {
        self.fetchGenerations = fetchGenerations
    }

    public func load() async {
        guard !state.isLoading else { return }
        state = .loading
        do {
            let generations = try await fetchGenerations()
            state = .loaded(generations)
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown)
        }
    }

    public func filteredGenerations() -> [Generation] {
        guard case let .loaded(generations) = state, !searchText.isEmpty else {
            return state.value ?? []
        }
        return generations.filter { $0.displayName.localizedCaseInsensitiveContains(searchText) }
    }
}
