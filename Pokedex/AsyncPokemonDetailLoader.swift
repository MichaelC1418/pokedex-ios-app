import SwiftUI

struct AsyncPokemonDetailLoader: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    let id: Int
    
    @State private var pokemon: Pokemon?
    @State private var error: String?
    
    var body: some View {
        Group {
            if let pokemon = pokemon {
                PokemonDetailView(
                    pokemon: pokemon,
                    showSharingControls: true
                )
            } else if let error = error {
                Text("Error: \(error)")
            } else {
                ProgressView("Loading…")
            }
        }
        .task {
            do {
                self.pokemon = try await pokemonStore.pokemonByID(id)
            } catch {
                self.error = error.localizedDescription
            }
        }
    }
}
