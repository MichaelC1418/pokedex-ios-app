import SwiftUI

extension Color {
    static let pokemonBlue = Color(red: 36/255, green: 90/255, blue: 170/255)
}

extension View {
    func pokemonFont(size: CGFloat) -> some View {
        self.font(.custom("PokemonSolid", size: size))
    }
}
