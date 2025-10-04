import SwiftUI
import PokemonDomain
import CoreKit

@MainActor
public final class FavoritesViewModel: ObservableObject {
    private let loadFavorites: LoadFavoritesUseCase

    @Published public private(set) var state: LoadableState<[PokemonDetail]> = .idle

    public init(loadFavorites: LoadFavoritesUseCase) {
        self.loadFavorites = loadFavorites
    }

    public func load() async {
        state = .loading
        await refresh()
    }

    public func refresh() async {
        do {
            let favorites = try await loadFavorites()
            if favorites.isEmpty {
                state = .loaded([])
            } else {
                state = .loaded(favorites.sorted(by: { $0.name < $1.name }))
            }
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown)
        }
    }
}
