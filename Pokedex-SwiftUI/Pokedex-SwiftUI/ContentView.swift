import SwiftUI
import HomeFeature
import FavoritesFeature
import PokemonDetailFeature
import AboutFeature

struct ContentView: View {
    private let dependencies: AppDependencies

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    var body: some View {
        TabView {
            HomeView(
                viewModelFactory: {
                    HomeViewModel(fetchGenerations: dependencies.fetchGenerations)
                },
                generationDetailFactory: { generation in
                    GenerationDetailViewModel(
                        generation: generation,
                        fetchPokemon: dependencies.fetchPokemonForGeneration
                    )
                },
                detailScreenFactory: { summary in
                    PokemonDetailScreen(identifier: String(summary.id)) {
                        PokemonDetailViewModel(
                            loadDetail: dependencies.loadPokemonDetail,
                            toggleFavorite: dependencies.toggleFavorite,
                            checkFavoriteStatus: dependencies.checkFavoriteStatus
                        )
                    }
                }
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }

            FavoritesView(
                viewModelFactory: {
                    FavoritesViewModel(loadFavorites: dependencies.loadFavorites)
                },
                detailScreenFactory: { detail in
                    PokemonDetailScreen(identifier: String(detail.id)) {
                        let viewModel = PokemonDetailViewModel(
                            loadDetail: dependencies.loadPokemonDetail,
                            toggleFavorite: dependencies.toggleFavorite,
                            checkFavoriteStatus: dependencies.checkFavoriteStatus
                        )
                        viewModel.prefill(detail: detail)
                        return viewModel
                    }
                }
            )
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView(dependencies: .live())
}
