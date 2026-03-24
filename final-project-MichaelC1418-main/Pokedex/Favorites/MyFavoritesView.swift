import SwiftUI

struct MyFavoritesView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var favorites: FavoritesStore
    @EnvironmentObject var pokemonStore: PokemonStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favorites.privateFavoriteIDs, id: \.self) { id in
                    NavigationLink {
                        AsyncPokemonDetailLoader(id: id)
                    } label: {
                        Text("Pokémon #\(id)")
                    }
                }
            }
            .navigationTitle("My Favorites")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
