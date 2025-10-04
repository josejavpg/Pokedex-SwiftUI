import SwiftUI

public enum AppColors {
    public static let background = Color(.systemBackground)
    public static let primaryText = Color(.label)
    public static let secondaryText = Color(.secondaryLabel)
    public static let accent = Color.red
}

public struct PokemonTypeBadge: View {
    private let typeName: String

    public init(typeName: String) {
        self.typeName = typeName
    }

    public var body: some View {
        Text(typeName.capitalized)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor(typeName: typeName))
            .foregroundStyle(Color.white)
            .clipShape(Capsule())
    }

    private func badgeColor(typeName: String) -> Color {
        switch typeName.lowercased() {
        case "fire": return Color.orange
        case "water": return Color.blue
        case "grass": return Color.green
        case "electric": return Color.yellow
        case "psychic": return Color.purple
        case "ice": return Color.cyan
        case "dragon": return Color(red: 0.4, green: 0.2, blue: 0.6)
        case "dark": return Color.black
        case "fairy": return Color.pink
        default: return Color.gray
        }
    }
}

public struct RemoteImage: View {
    private let url: URL?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .transition(.opacity)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(AppColors.secondaryText)
            @unknown default:
                EmptyView()
            }
        }
    }
}

public struct EmptyStateView: View {
    private let systemImage: String
    private let title: String
    private let subtitle: String?

    public init(systemImage: String, title: String, subtitle: String? = nil) {
        self.systemImage = systemImage
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundStyle(AppColors.secondaryText)
            Text(title)
                .font(.headline)
            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}
