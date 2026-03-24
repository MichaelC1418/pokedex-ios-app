import SwiftUI

struct HomeView: View {
    @EnvironmentObject var pokemonOfTheDay: PokemonOfTheDayManager

    var body: some View {
        ZStack {
            Color.pokemonBlue.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text("POKÉMON OF THE DAY")
                        .pokemonFont(size: 32)
                        .foregroundColor(.yellow)
                        .padding(.top, 20)

                    Text("Michael Chavez - Z23616307")
                        .pokemonFont(size: 16)
                        .foregroundColor(.white.opacity(0.9))

                    if let p = pokemonOfTheDay.pokemon {
                        PokemonDetailView(pokemon: p, showSharingControls: true)
                            .padding(.top, 10)
                    } else {
                        ProgressView("Loading…")
                            .pokemonFont(size: 16)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear { pokemonOfTheDay.load() }
    }
}
