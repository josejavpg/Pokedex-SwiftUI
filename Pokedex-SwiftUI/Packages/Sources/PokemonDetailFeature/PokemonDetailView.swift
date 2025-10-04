import SwiftUI
import PokemonDomain
import DesignSystem
import CoreKit

public struct PokemonDetailScreen: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    private let identifier: String

    public init(identifier: String, viewModelFactory: @escaping () -> PokemonDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModelFactory())
        self.identifier = identifier
    }

    public var body: some View {
        content
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.load(identifier: identifier)
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
                title: "Something went wrong",
                subtitle: error.errorDescription
            )
        case .loaded(let detail):
            ScrollView {
                VStack(spacing: 16) {
                    RemoteImage(url: detail.imageURL)
                        .frame(height: 200)
                        .padding(.top, 24)

                    Text(detail.displayName)
                        .font(.largeTitle.weight(.bold))

                    typesView(detail)

                    metricsView(detail)

                    gamesView(detail)

                    favoriteButton
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(AppColors.background)
        }
    }

    private func typesView(_ detail: PokemonDetail) -> some View {
        HStack(spacing: 8) {
            ForEach(detail.types, id: \.slot) { type in
                PokemonTypeBadge(typeName: type.name)
            }
        }
    }

    private func metricsView(_ detail: PokemonDetail) -> some View {
        HStack(spacing: 16) {
            metricItem(title: "Height", value: detail.formattedHeight)
            metricItem(title: "Weight", value: detail.formattedWeight)
        }
    }

    private func metricItem(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppColors.secondaryText)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func gamesView(_ detail: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Appears In")
                .font(.headline)
            if detail.gameVersions.isEmpty {
                Text("No game information available.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                    ForEach(detail.gameVersions, id: \.name) { version in
                        Text(version.displayName)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.tertiarySystemFill))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var favoriteButton: some View {
        Button {
            Task {
                await viewModel.toggleFavoriteState()
            }
        } label: {
            Label(
                viewModel.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                systemImage: viewModel.isFavorite ? "heart.fill" : "heart"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isFavorite ? Color.red.opacity(0.2) : Color.red)
            .foregroundStyle(viewModel.isFavorite ? Color.red : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
