import Foundation

struct Pokemon: Identifiable, Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [TypeEntry]
    let abilities: [AbilityEntry]
    let stats: [StatEntry]

    // Species description (optional)
    var description: String?

    // Computed
    var imageURL: String {
        sprites.other.officialArtwork.frontDefault
    }

    var typeNames: [String] {
        types.map { $0.type.name.capitalized }
    }

    var abilityNames: [String] {
        abilities.map { $0.ability.name.capitalized }
    }
}

// MARK: - Sprites
struct Sprites: Codable {
    let other: OtherSprites
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Types
struct TypeEntry: Codable {
    let type: NamedAPIResource
}

// MARK: - Abilities
struct AbilityEntry: Codable {
    let ability: NamedAPIResource
}

// MARK: - Stats
struct StatEntry: Codable {
    let baseStat: Int
    let stat: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct NamedAPIResource: Codable {
    let name: String
    let url: String
}
