import SwiftUI

@main
struct Pokedex_SwiftUIApp: App {
    private let dependencies = AppDependencies.live()

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
                .preferredColorScheme(.light)
        }
    }
}
