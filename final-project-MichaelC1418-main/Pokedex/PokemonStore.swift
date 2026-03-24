import SwiftUI

@MainActor
class PokemonStore: ObservableObject {
    @Published var cache: [Int : Pokemon] = [:]
    
    private let api = PokemonAPI()
    
    func pokemonByID(_ id: Int) async throws -> Pokemon {
        // If cached, return immediately
        if let existing = cache[id] {
            return existing
        }
        
        // Otherwise fetch from API
        let pokemon = try await api.fetchPokemon(byId: id)
        cache[id] = pokemon
        return pokemon
    }
}
