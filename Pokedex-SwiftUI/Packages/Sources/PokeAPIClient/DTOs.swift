import Foundation

public struct NamedAPIResource: Decodable, Sendable {
    public let name: String
    public let url: URL
}

public struct NamedAPIResourceList: Decodable, Sendable {
    public let results: [NamedAPIResource]
}

public struct GenerationSummaryDTO: Sendable {
    public let id: Int
    public let name: String

    public init?(resource: NamedAPIResource) {
        guard let id = resource.url.extractedIdentifier else {
            return nil
        }
        self.id = id
        self.name = resource.name
    }
}

public struct GenerationDetailDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let pokemonSpecies: [NamedAPIResource]
}

public struct PokemonSummaryDTO: Sendable {
    public let id: Int
    public let name: String

    public init?(resource: NamedAPIResource) {
        guard let id = resource.url.extractedIdentifier else {
            return nil
        }
        self.id = id
        self.name = resource.name
    }
}

public struct PokemonDetailDTO: Decodable, Sendable {
    public struct PokemonTypeEntry: Decodable, Sendable {
        public let slot: Int
        public let type: NamedAPIResource
    }

    public struct PokemonGameIndex: Decodable, Sendable {
        public let version: NamedAPIResource
    }

    public struct Sprites: Decodable, Sendable {
        public let frontDefault: URL?
        public let other: OtherSprites?

        public struct OtherSprites: Decodable, Sendable {
            public let officialArtwork: Artwork?

            private enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }

            public struct Artwork: Decodable, Sendable {
                public let frontDefault: URL?
            }
        }
    }

    public let id: Int
    public let name: String
    public let height: Int
    public let weight: Int
    public let types: [PokemonTypeEntry]
    public let gameIndices: [PokemonGameIndex]
    public let sprites: Sprites
}

private extension URL {
    var extractedIdentifier: Int? {
        pathComponents.reversed().compactMap(Int.init).first
    }
}
