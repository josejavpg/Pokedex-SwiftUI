import Foundation
import PokeAPIClient
import PersistenceKit
import PokemonData
import PokemonDomain

struct AppDependencies {
    let repository: PokemonRepository
    let fetchGenerations: FetchGenerationsUseCase
    let fetchPokemonForGeneration: FetchPokemonForGenerationUseCase
    let loadPokemonDetail: LoadPokemonDetailUseCase
    let toggleFavorite: ToggleFavoriteUseCase
    let loadFavorites: LoadFavoritesUseCase
    let checkFavoriteStatus: CheckFavoriteStatusUseCase

    static func live() -> AppDependencies {
        let apiClient = URLSessionPokemonAPIClient()
        let favoritesStore = SwiftDataFavoritesStore()
        let repository = PokemonDataRepository(apiClient: apiClient, favoritesStore: favoritesStore)

        return AppDependencies(
            repository: repository,
            fetchGenerations: FetchGenerationsUseCase(repository: repository),
            fetchPokemonForGeneration: FetchPokemonForGenerationUseCase(repository: repository),
            loadPokemonDetail: LoadPokemonDetailUseCase(repository: repository),
            toggleFavorite: ToggleFavoriteUseCase(repository: repository),
            loadFavorites: LoadFavoritesUseCase(repository: repository),
            checkFavoriteStatus: CheckFavoriteStatusUseCase(repository: repository)
        )
    }
}
