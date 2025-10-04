import SwiftUI
import PokemonDomain
import PokemonDetailFeature
import DesignSystem
import CoreKit

struct GenerationDetailView: View {
    @StateObject private var viewModel: GenerationDetailViewModel
    private let detailScreenFactory: (PokemonSummary) -> PokemonDetailScreen

    init(viewModel: GenerationDetailViewModel, detailScreenFactory: @escaping (PokemonSummary) -> PokemonDetailScreen) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.detailScreenFactory = detailScreenFactory
    }

    var body: some View {
        content
            .navigationTitle(viewModel.title)
            .task {
                await viewModel.load()
            }
            .navigationDestination(for: PokemonSummary.self) { summary in
                detailScreenFactory(summary)
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
                title: "Failed to load Pokémon",
                subtitle: error.errorDescription
            )
        case .loaded(let pokemon):
            List(pokemon) { summary in
                NavigationLink(value: summary) {
                    HStack {
                        Text("#\(summary.id)")
                            .font(.caption)
                            .foregroundStyle(AppColors.secondaryText)
                        Text(summary.displayName)
                            .font(.body)
                    }
                }
            }
        }
    }
}
