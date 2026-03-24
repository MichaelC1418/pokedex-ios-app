import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var auth: AuthManager
    @Environment(\.dismiss) var dismiss

    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)

                Button("Update Password") {
                    Task {
                        await updatePassword()
                    }
                }
                .buttonStyle(.borderedProminent)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.caption)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Change Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func updatePassword() async {
        guard newPassword == confirmPassword else {
            errorMessage = "Passwords do not match."
            successMessage = ""
            return
        }
        do {
            try await auth.updatePassword(newPassword: newPassword)
            errorMessage = ""
            successMessage = "Password updated successfully."
            newPassword = ""
            confirmPassword = ""
        } catch {
            errorMessage = error.localizedDescription
            successMessage = ""
        }
    }
}
