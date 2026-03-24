import Foundation
import FirebaseAuth

@MainActor
class AuthManager: ObservableObject {
    @Published var user: User?

    init() {
        self.user = Auth.auth().currentUser
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }

    func login(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func register(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func logout() {
        try? Auth.auth().signOut()
    }

    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        try await user.updatePassword(to: newPassword)
    }

    var userEmail: String {
        user?.email ?? "Unknown"
    }

    var userId: String? {
        user?.uid
    }
}
