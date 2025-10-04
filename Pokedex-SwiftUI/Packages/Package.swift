// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "PokedexModules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "CoreKit", targets: ["CoreKit"]),
        .library(name: "PokeAPIClient", targets: ["PokeAPIClient"]),
        .library(name: "PersistenceKit", targets: ["PersistenceKit"]),
        .library(name: "PokemonDomain", targets: ["PokemonDomain"]),
        .library(name: "PokemonData", targets: ["PokemonData"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "HomeFeature", targets: ["HomeFeature"]),
        .library(name: "FavoritesFeature", targets: ["FavoritesFeature"]),
        .library(name: "PokemonDetailFeature", targets: ["PokemonDetailFeature"]),
        .library(name: "AboutFeature", targets: ["AboutFeature"])
    ],
    targets: [
        .target(
            name: "CoreKit"
        ),
        .target(
            name: "PokeAPIClient",
            dependencies: [
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "PersistenceKit",
            dependencies: [
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "PokemonDomain",
            dependencies: [
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "PokemonData",
            dependencies: [
                .target(name: "PokeAPIClient"),
                .target(name: "PersistenceKit"),
                .target(name: "PokemonDomain"),
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "DesignSystem"
        ),
        .target(
            name: "PokemonDetailFeature",
            dependencies: [
                .target(name: "PokemonDomain"),
                .target(name: "DesignSystem"),
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                .target(name: "PokemonDomain"),
                .target(name: "PokemonDetailFeature"),
                .target(name: "DesignSystem"),
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "FavoritesFeature",
            dependencies: [
                .target(name: "PokemonDomain"),
                .target(name: "PokemonDetailFeature"),
                .target(name: "DesignSystem"),
                .target(name: "CoreKit")
            ]
        ),
        .target(
            name: "AboutFeature",
            dependencies: [
                .target(name: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "CoreKitTests",
            dependencies: ["CoreKit"]
        ),
        .testTarget(
            name: "PokeAPIClientTests",
            dependencies: ["PokeAPIClient"]
        ),
        .testTarget(
            name: "PersistenceKitTests",
            dependencies: ["PersistenceKit"]
        ),
        .testTarget(
            name: "PokemonDomainTests",
            dependencies: ["PokemonDomain"]
        ),
        .testTarget(
            name: "PokemonDataTests",
            dependencies: ["PokemonData"]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        ),
        .testTarget(
            name: "FavoritesFeatureTests",
            dependencies: ["FavoritesFeature"]
        ),
        .testTarget(
            name: "PokemonDetailFeatureTests",
            dependencies: ["PokemonDetailFeature"]
        ),
        .testTarget(
            name: "AboutFeatureTests",
            dependencies: ["AboutFeature"]
        )
    ]
)
