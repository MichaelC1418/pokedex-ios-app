import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct PokedexApp: App {
    init() {
        FirebaseApp.configure()
    }
    @StateObject var pokemonOfTheDay = PokemonOfTheDayManager()
    @StateObject private var authManager = AuthManager()
    @StateObject private var favoritesStore = FavoritesStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authManager)
                .environmentObject(favoritesStore)
                .environmentObject(pokemonOfTheDay)
            
        }
    }
}
