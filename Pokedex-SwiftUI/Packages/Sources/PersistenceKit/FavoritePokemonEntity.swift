import Foundation
import SwiftData
import CoreKit

@Model
public final class FavoritePokemonEntity {
    @Attribute(.unique) public var id: Int
    public var name: String
    public var imageURL: URL?
    public var height: Int
    public var weight: Int
    public var types: [String]
    public var gameVersions: [String]

    public init(
        id: Int,
        name: String,
        imageURL: URL?,
        height: Int,
        weight: Int,
        types: [String],
        gameVersions: [String]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.height = height
        self.weight = weight
        self.types = types
        self.gameVersions = gameVersions
    }
}

public struct FavoritePokemonRecord: Sendable {
    public let id: Int
    public let name: String
    public let imageURL: URL?
    public let height: Int
    public let weight: Int
    public let types: [String]
    public let gameVersions: [String]

    public init(
        id: Int,
        name: String,
        imageURL: URL?,
        height: Int,
        weight: Int,
        types: [String],
        gameVersions: [String]
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.height = height
        self.weight = weight
        self.types = types
        self.gameVersions = gameVersions
    }
}

public protocol FavoritesStore: Sendable {
    @MainActor func fetchFavorites() throws -> [FavoritePokemonEntity]
    @MainActor func favorite(withID id: Int) throws -> FavoritePokemonEntity?
    @MainActor func save(record: FavoritePokemonRecord) throws
    @MainActor func removeFavorite(withID id: Int) throws
}

public final class SwiftDataFavoritesStore: FavoritesStore {
    private let container: ModelContainer

    @MainActor
    private var context: ModelContext {
        container.mainContext
    }

    public init(container: ModelContainer) {
        self.container = container
    }

    public convenience init() {
        do {
            let schema = Schema([FavoritePokemonEntity.self])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [configuration])
            self.init(container: container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    @MainActor
    public func fetchFavorites() throws -> [FavoritePokemonEntity] {
        try context.fetch(FetchDescriptor<FavoritePokemonEntity>(sortBy: [SortDescriptor(\.name)]))
    }

    @MainActor
    public func favorite(withID id: Int) throws -> FavoritePokemonEntity? {
        let predicate = #Predicate<FavoritePokemonEntity> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    @MainActor
    public func save(record: FavoritePokemonRecord) throws {
        if let existing = try favorite(withID: record.id) {
            existing.name = record.name
            existing.imageURL = record.imageURL
            existing.height = record.height
            existing.weight = record.weight
            existing.types = record.types
            existing.gameVersions = record.gameVersions
        } else {
            let entity = FavoritePokemonEntity(
                id: record.id,
                name: record.name.capitalized,
                imageURL: record.imageURL,
                height: record.height,
                weight: record.weight,
                types: record.types,
                gameVersions: record.gameVersions
            )
            context.insert(entity)
        }
        try context.save()
    }

    @MainActor
    public func removeFavorite(withID id: Int) throws {
        guard let entity = try favorite(withID: id) else {
            throw AppError.notFound
        }
        context.delete(entity)
        try context.save()
    }
}
