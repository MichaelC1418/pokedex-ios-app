import Foundation
import FirebaseFirestore
import FirebaseAuth

struct SharedFavorite: Identifiable {
    let id: String
    let pokemonId: Int
    let pokemonName: String
    let pokemonImageURL: String
    let userEmail: String
    let caption: String
    let timestamp: Date
}

@MainActor
class FavoritesStore: ObservableObject {
    @Published var privateFavoriteIDs: [Int] = []
    @Published var sharedFavorites: [SharedFavorite] = []

    private let db = Firestore.firestore()

    // MARK: - PRIVATE FAVORITES
    func loadPrivateFavorites(for userId: String) {
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .addSnapshotListener { snapshot, _ in
                guard let docs = snapshot?.documents else { return }

                self.privateFavoriteIDs = docs.compactMap { doc in
                    doc.data()["pokemonId"] as? Int
                }
            }
    }

    func togglePrivateFavorite(pokemonId: Int, for userId: String) {
        let ref = db.collection("users")
            .document(userId)
            .collection("favorites")
            .document("\(pokemonId)")

        if privateFavoriteIDs.contains(pokemonId) {
            ref.delete()
        } else {
            ref.setData([
                "pokemonId": pokemonId,
                "timestamp": Timestamp(date: Date())
            ])
        }
    }

    func isFavorite(pokemonId: Int) -> Bool {
        privateFavoriteIDs.contains(pokemonId)
    }

    // MARK: - PUBLIC FAVORITES
    func startListeningToSharedFavorites() {
        print("DEBUG: Listening to sharedFavorites collection")

        db.collection("sharedFavorites")   // <-- FIXED HERE
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    print("DEBUG: Error loading sharedFavorites:", error)
                }

                guard let docs = snapshot?.documents else { return }

                self.sharedFavorites = docs.compactMap { doc in
                    let data = doc.data()
                    guard
                        let pokemonId = data["pokemonId"] as? Int,
                        let pokemonName = data["pokemonName"] as? String,
                        let pokemonImageURL = data["pokemonImageURL"] as? String,
                        let caption = data["caption"] as? String,
                        let userEmail = data["userEmail"] as? String,
                        let ts = data["timestamp"] as? Timestamp
                    else { return nil }

                    return SharedFavorite(
                        id: doc.documentID,
                        pokemonId: pokemonId,
                        pokemonName: pokemonName,
                        pokemonImageURL: pokemonImageURL,
                        userEmail: userEmail,
                        caption: caption,
                        timestamp: ts.dateValue()
                    )
                }
            }
    }

    // MARK: - SHARE A FAVORITE PUBLICLY
    func shareFavoritePublicly(pokemon: Pokemon, caption: String, auth: AuthManager) async throws {

        let email = auth.userEmail
        let doc = db.collection("sharedFavorites").document()

        let data: [String: Any] = [
            "pokemonId": pokemon.id,
            "pokemonName": pokemon.name,
            "pokemonImageURL": pokemon.imageURL,
            "caption": caption,
            "userEmail": email,
            "timestamp": Timestamp(date: Date())
        ]

        try await doc.setData(data)
    }
}
