import SwiftUI
import DesignSystem

public struct AboutView: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About Pokedex")
                    .font(.largeTitle.weight(.bold))

                Text("Pokedex-SwiftUI is an educational project that showcases SwiftUI, SwiftData, and Swift Testing while integrating with the public PokeAPI. Browse generations, discover Pokémon, and build your favourites list even when offline.")
                    .font(.body)
                    .foregroundStyle(AppColors.secondaryText)

                Divider()

                section(title: "Technologies") {
                    bullet("SwiftUI for the user interface")
                    bullet("SwiftData for local persistence of favourites")
                    bullet("Swift Testing for unit and integration tests")
                    bullet("Modular architecture powered by Swift Package Manager")
                }

                section(title: "Data Source") {
                    Text("Pokémon data is provided by the public PokeAPI (https://pokeapi.co).").foregroundStyle(AppColors.secondaryText)
                }

                section(title: "Credits") {
                    bullet("Pokémon and Pokémon character names are trademarks of Nintendo.")
                    bullet("Design inspired by classic Pokédex entries.")
                }
            }
            .padding()
        }
        .background(AppColors.background)
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
            content()
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
            Text(text)
                .foregroundStyle(AppColors.secondaryText)
        }
    }
}
