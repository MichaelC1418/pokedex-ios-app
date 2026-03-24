import Foundation

struct GlobalSharedFavorite: Identifiable, Codable {
    var id: String
    var pokemonId: Int
    var pokemonName: String
    var pokemonImageURL: String
    var caption: String
    var userEmail: String

    enum CodingKeys: String, CodingKey {
        case id
        case pokemonId
        case pokemonName
        case pokemonImageURL
        case caption
        case userEmail
    }
}
