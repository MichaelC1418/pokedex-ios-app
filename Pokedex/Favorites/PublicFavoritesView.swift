import SwiftUI

struct PublicFavoritesView: View {

    @EnvironmentObject var favorites: FavoritesStore

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 22) {

                    if favorites.sharedFavorites.isEmpty {
                        Text("No public favorites yet.")
                            .foregroundColor(.white)
                            .pokemonFont(size: 20)
                            .padding(.top, 40)
                    }

                    ForEach(favorites.sharedFavorites) { fav in
                        PublicFavoriteCard(fav: fav)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.pokemonBlue.ignoresSafeArea())
            .navigationTitle("Public Favorites")
            .onAppear {
                favorites.startListeningToSharedFavorites()
            }
        }
    }
}

struct PublicFavoriteCard: View {

    let fav: SharedFavorite

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Image
            AsyncImage(url: URL(string: fav.pokemonImageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let img):
                    img.resizable()
                        .scaledToFit()
                        .frame(maxWidth: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(radius: 8)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)

            // Title
            Text("#\(fav.pokemonId) \(fav.pokemonName.capitalized)")
                .foregroundColor(.yellow)
                .pokemonFont(size: 26)

            // Caption
            if !fav.caption.isEmpty {
                Text(fav.caption)
                    .foregroundColor(.white)
                    .pokemonFont(size: 16)
                    .padding(.top, 4)
            }

            // User
            Text("Shared by: \(fav.userEmail)")
                .foregroundColor(.white.opacity(0.8))
                .font(.caption)

        }
        .padding()
        .background(Color.white.opacity(0.12))
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
