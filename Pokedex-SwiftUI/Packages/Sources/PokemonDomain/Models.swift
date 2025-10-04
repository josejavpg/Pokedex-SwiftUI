import Foundation

public struct Generation: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    public var displayName: String {
        name.capitalized
    }
}

public struct PokemonSummary: Identifiable, Hashable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    public var displayName: String {
        name.capitalized
    }
}

public struct PokemonDetail: Identifiable, Sendable, Equatable {
    public struct PokemonType: Hashable, Sendable {
        public let name: String
        public let slot: Int

        public init(name: String, slot: Int) {
            self.name = name
            self.slot = slot
        }

        public var displayName: String {
            name.capitalized
        }
    }

    public struct GameVersion: Hashable, Sendable {
        public let name: String

        public init(name: String) {
            self.name = name
        }

        public var displayName: String {
            name.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }

    public let id: Int
    public let name: String
    public let imageURL: URL?
    public let height: Int
    public let weight: Int
    public let types: [PokemonType]
    public let gameVersions: [GameVersion]

    public init(
        id: Int,
        name: String,
        imageURL: URL?,
        height: Int,
        weight: Int,
        types: [PokemonType],
        gameVersions: [GameVersion]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.height = height
        self.weight = weight
        self.types = types.sorted(by: { $0.slot < $1.slot })
        self.gameVersions = gameVersions
    }

    public var displayName: String {
        name.capitalized
    }

    public var formattedHeight: String {
        String(format: "%.1f m", Double(height) / 10.0)
    }

    public var formattedWeight: String {
        String(format: "%.1f kg", Double(weight) / 10.0)
    }
}
