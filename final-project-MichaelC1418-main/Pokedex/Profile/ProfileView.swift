import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var favorites: FavoritesStore

    @State private var showChangePassword = false
    @State private var showMyFavorites = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()

                Text("Email: \(auth.userEmail)")
                    .font(.subheadline)

                Button("My Favorites") {
                    showMyFavorites = true
                }
                .buttonStyle(.bordered)

                Button("Change Password") {
                    showChangePassword = true
                }
                .buttonStyle(.bordered)

                Button("Logout") {
                    auth.logout()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .sheet(isPresented: $showChangePassword) {
                ChangePasswordView()
                    .environmentObject(auth)
            }
            .sheet(isPresented: $showMyFavorites) {
                MyFavoritesView()
                    .environmentObject(auth)
                    .environmentObject(favorites)
            }
        }
        .onAppear {
            if let uid = auth.userId {
                favorites.loadPrivateFavorites(for: uid)
            }
        }
    }
}
