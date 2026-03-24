import SwiftUI

struct PokemonDetailView: View {

    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var favorites: FavoritesStore

    let pokemon: Pokemon
    let showSharingControls: Bool   // used for Home/Search so they can share

    @State private var showCaptionBox = false
    @State private var captionText = ""
    @State private var shareError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Pokémon Image
                AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let img):
                        img.resizable()
                            .scaledToFit()
                            .frame(maxWidth: 260)
                            .shadow(radius: 10)
                            .padding(.top, 12)
                    case .failure:
                        Image(systemName: "questionmark.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                // MARK: - Name / Number
                Text("#\(pokemon.id) \(pokemon.name.capitalized)")
                    .font(.custom("PokemonSolid", size: 32))
                    .foregroundColor(.yellow)

                // MARK: - Types / Abilities
                VStack(alignment: .leading, spacing: 6) {

                    // Types
                    Text("Type: \(pokemon.typeNames.joined(separator: ", "))")
                        .font(.headline)
                        .foregroundColor(.white)

                    // Abilities
                    if !pokemon.abilityNames.isEmpty {
                        Text("Abilities: \(pokemon.abilityNames.joined(separator: ", "))")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }

                // MARK: - Description (from species)
                if let desc = pokemon.description {
                    Text(desc)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.body)
                        .padding(.top, 4)
                }

                // MARK: - Base Stats
                if !pokemon.stats.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Base Stats")
                            .font(.custom("PokemonSolid", size: 24))
                            .foregroundColor(.yellow)

                        ForEach(pokemon.stats, id: \.stat.name) { entry in
                            HStack {
                                Text(entry.stat.name.capitalized)
                                    .foregroundColor(.white)

                                Spacer()

                                Text("\(entry.baseStat)")
                                    .foregroundColor(.white)
                            }
                            .font(.subheadline)
                        }
                    }
                    .padding(.top, 8)
                }

                // MARK: - Favorite / Share
                if let userId = auth.userId {
                    HStack(spacing: 18) {

                        // Private favorite toggle
                        Button {
                            favorites.togglePrivateFavorite(
                                pokemonId: pokemon.id,
                                for: userId
                            )
                        } label: {
                            HStack {
                                Image(
                                    systemName: favorites.isFavorite(pokemonId: pokemon.id)
                                    ? "star.fill"
                                    : "star"
                                )
                                Text("Favorite")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.yellow)

                        // Public share
                        if showSharingControls {
                            Button {
                                withAnimation { showCaptionBox.toggle() }
                            } label: {
                                HStack {
                                    Image(systemName: "heart.fill")
                                    Text("Share Publicly")
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(.pink)
                        }
                    }

                    // MARK: - Caption + Confirm Share
                    if showCaptionBox {
                        VStack(alignment: .leading, spacing: 10) {

                            Text("Caption (optional):")
                                .foregroundColor(.white.opacity(0.9))
                                .font(.headline)

                            TextField(
                                "Why do you like this Pokémon?",
                                text: $captionText,
                                axis: .vertical
                            )
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)

                            Button("Confirm Share") {
                                Task {
                                    do {
                                        try await favorites.shareFavoritePublicly(
                                            pokemon: pokemon,
                                            caption: captionText,
                                            auth: auth
                                        )
                                        captionText = ""
                                        showCaptionBox = false
                                        shareError = nil
                                    } catch {
                                        shareError = error.localizedDescription
                                    }
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.pink)

                            if let shareError {
                                Text(shareError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                        .padding(.top)
                    }
                } else {
                    Text("Login to favorite or share this Pokémon.")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption)
                }
            }
            .padding()
        }
        .background(Color.pokemonBlue.ignoresSafeArea())
    }
}
