import SwiftUI

struct SearchView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var favorites: FavoritesStore

    @State private var searchText = ""
    @State private var currentPokemon: Pokemon?
    @State private var searchHistory: [Pokemon] = []
    @State private var isLoading = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // SEARCH BAR
                    TextField("Enter Pokémon name or ID", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .pokemonFont(size: 18)

                    Button("Search") {
                        Task { await performSearch() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.yellow)
                    .foregroundColor(.blue)
                    .pokemonFont(size: 18)

                    // LOADING
                    if isLoading {
                        ProgressView("Loading...")
                            .foregroundColor(.white)
                            .pokemonFont(size: 18)
                    }

                    // FOUND POKEMON (NO SCROLLING REQUIRED)
                    if let pokemon = currentPokemon {
                        PokemonDetailView(
                            pokemon: pokemon,
                            showSharingControls: true
                        )
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }

                    // ERROR MESSAGE
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .pokemonFont(size: 16)
                    }

                    // SEARCH HISTORY
                    if !searchHistory.isEmpty {
                        Text("Previous Searches")
                            .foregroundColor(.yellow)
                            .pokemonFont(size: 22)

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(searchHistory) { poke in
                                Button {
                                    currentPokemon = poke
                                } label: {
                                    HStack {
                                        AsyncImage(url: URL(string: poke.imageURL)) { img in
                                            img.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))

                                        Text("#\(poke.id) \(poke.name.capitalized)")
                                            .pokemonFont(size: 16)
                                            .foregroundColor(.white)

                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 20)
            }
            .background(Color.pokemonBlue.ignoresSafeArea())
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Search Function
    private func performSearch() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        isLoading = true
        currentPokemon = nil
        errorMessage = ""

        do {
            let result: Pokemon

            if let id = Int(query) {
                result = try await PokemonAPI.shared.fetchPokemon(byId: id)
            } else {
                result = try await PokemonAPI.shared.fetchPokemon(byName: query)
            }

            currentPokemon = result

            // add to search history
            if !searchHistory.contains(where: { $0.id == result.id }) {
                searchHistory.insert(result, at: 0)
            }

        } catch {
            errorMessage = "Pokémon not found."
        }

        isLoading = false
    }
}
