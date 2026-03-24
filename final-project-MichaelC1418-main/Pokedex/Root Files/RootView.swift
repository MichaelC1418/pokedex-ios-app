import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        NavigationView {
            if auth.user == nil {
                LoginView()
            } else {
                MainTabView()
            }
        }
    }
}
