import SwiftUI
import PokemonDomain
import PokemonDetailFeature
import DesignSystem
import CoreKit

public struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    private let detailScreenFactory: (PokemonDetail) -> PokemonDetailScreen

    public init(
        viewModelFactory: @escaping () -> FavoritesViewModel,
        detailScreenFactory: @escaping (PokemonDetail) -> PokemonDetailScreen
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.detailScreenFactory = detailScreenFactory
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Favorites")
                .background(Color(.systemBackground))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let error):
            EmptyStateView(
                systemImage: "exclamationmark.triangle",
                title: "Unable to load favorites",
                subtitle: error.errorDescription
            )
        case .loaded(let favorites):
            if favorites.isEmpty {
                EmptyStateView(
                    systemImage: "heart",
                    title: "No favorites yet",
                    subtitle: "Tap the heart icon on a Pokémon to add it here."
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(favorites) { detail in
                    NavigationLink {
                        detailScreenFactory(detail)
                    } label: {
                        HStack(spacing: 12) {
                            RemoteImage(url: detail.imageURL)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(detail.displayName)
                                    .font(.headline)
                                Text(detail.types.map(\.displayName).joined(separator: ", "))
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.secondaryText)
                            }
                        }
                    }
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
    }
}
