import SwiftUI
import PokemonDomain
import CoreKit

@MainActor
public final class PokemonDetailViewModel: ObservableObject {
    private let loadDetail: LoadPokemonDetailUseCase
    private let toggleFavorite: ToggleFavoriteUseCase
    private let checkFavoriteStatus: CheckFavoriteStatusUseCase

    @Published public private(set) var state: LoadableState<PokemonDetail> = .idle
    @Published public private(set) var isFavorite: Bool = false
    private var lastIdentifier: String?
    private var prefetchedDetail: PokemonDetail?

    public init(
        loadDetail: LoadPokemonDetailUseCase,
        toggleFavorite: ToggleFavoriteUseCase,
        checkFavoriteStatus: CheckFavoriteStatusUseCase
    ) {
        self.loadDetail = loadDetail
        self.toggleFavorite = toggleFavorite
        self.checkFavoriteStatus = checkFavoriteStatus
    }

    public func prefill(detail: PokemonDetail) {
        prefetchedDetail = detail
        state = .loaded(detail)
        isFavorite = true
    }

    public func load(identifier: String) async {
        if lastIdentifier == identifier {
            return
        }
        lastIdentifier = identifier

        if prefetchedDetail?.id != Int(identifier) {
            prefetchedDetail = nil
            state = .loading
        }

        do {
            let detail = try await loadDetail(identifier: identifier)
            state = .loaded(detail)
            isFavorite = try await checkFavoriteStatus(id: detail.id)
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown)
        }
    }

    public func toggleFavoriteState() async {
        guard case let .loaded(detail) = state else { return }
        do {
            let newState = try await toggleFavorite(detail: detail)
            isFavorite = newState
        } catch let error as AppError {
            state = .failed(error)
        } catch {
            state = .failed(.unknown)
        }
    }
}
