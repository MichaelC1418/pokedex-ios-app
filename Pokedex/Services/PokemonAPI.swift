import Foundation

class PokemonAPI {
    static let shared = PokemonAPI()

    // MARK: - Fetch Pokémon by ID
    func fetchPokemon(byId id: Int) async throws -> Pokemon {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        var pokemon = try JSONDecoder().decode(Pokemon.self, from: data)

        // Fetch species for description
        let species = try await fetchSpecies(byId: id)

        if let englishText = species.flavorTextEntries
            .first(where: { $0.language.name == "en" })?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ") {

            pokemon.description = englishText
        }

        return pokemon
    }

    // MARK: - Fetch Pokémon by Name
    func fetchPokemon(byName name: String) async throws -> Pokemon {
        let lowered = name.lowercased()
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(lowered)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let poke = try JSONDecoder().decode(Pokemon.self, from: data)

        // Fetch species for description
        let species = try await fetchSpecies(byId: poke.id)

        var pokemon = poke

        if let englishText = species.flavorTextEntries
            .first(where: { $0.language.name == "en" })?
            .flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ") {

            pokemon.description = englishText
        }

        return pokemon
    }

    // MARK: - Fetch Species (for description + extra details)
    func fetchSpecies(byId id: Int) async throws -> PokemonSpecies {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(PokemonSpecies.self, from: data)
    }
}
