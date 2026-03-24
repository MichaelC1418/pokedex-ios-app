import Foundation

@MainActor
class PokemonOfTheDayManager: ObservableObject {

    @Published var pokemon: Pokemon?

    private let api = PokemonAPI.shared
    private let calendar = Calendar.current

    func load() {
        Task {
            await fetchPokemonOfTheDay()
        }
    }

    private func fetchPokemonOfTheDay() async {
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let pokemonId = ((dayOfYear - 1) % 898) + 1

        do {
            let fetched = try await api.fetchPokemon(byId: pokemonId)
            self.pokemon = fetched
        } catch {
            print(" Error loading Pokémon of the day:", error)
        }
    }
}
