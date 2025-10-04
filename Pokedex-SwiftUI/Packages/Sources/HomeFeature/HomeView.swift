import SwiftUI
import PokemonDomain
import PokemonDetailFeature
import DesignSystem
import CoreKit

public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let generationDetailFactory: (Generation) -> GenerationDetailViewModel
    private let detailScreenFactory: (PokemonSummary) -> PokemonDetailScreen

    public init(
        viewModelFactory: @escaping () -> HomeViewModel,
        generationDetailFactory: @escaping (Generation) -> GenerationDetailViewModel,
        detailScreenFactory: @escaping (PokemonSummary) -> PokemonDetailScreen
    ) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.generationDetailFactory = generationDetailFactory
        self.detailScreenFactory = detailScreenFactory
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokedex")
                .searchable(text: $viewModel.searchText)
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
                title: "Unable to load generations",
                subtitle: error.errorDescription
            )
        case .loaded:
            List(filteredGenerations) { generation in
                NavigationLink(value: generation) {
                    VStack(alignment: .leading) {
                        Text(generation.displayName)
                            .font(.headline)
                        Text("Generation #\(generation.id)")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.secondaryText)
                    }
                }
            }
            .navigationDestination(for: Generation.self) { generation in
                GenerationDetailView(
                    viewModel: generationDetailFactory(generation),
                    detailScreenFactory: { summary in
                        detailScreenFactory(summary)
                    }
                )
            }
        }
    }

    private var filteredGenerations: [Generation] {
        viewModel.filteredGenerations()
    }
}
