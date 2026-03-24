import Foundation

/// Extra species data for a Pokémon: flavor text, egg groups, growth rate, etc.
struct PokemonSpecies: Codable {
    struct FlavorTextEntry: Codable {
        let flavorText: String
        let language: NamedAPIResource
        let version: NamedAPIResource

        enum CodingKeys: String, CodingKey {
            case flavorText = "flavor_text"
            case language
            case version
        }
    }

    let id: Int
    let name: String

    let flavorTextEntries: [FlavorTextEntry]
    let captureRate: Int
    let baseHappiness: Int?
    let genderRate: Int           // -1 = genderless, 0–8 = female ratio
    let eggGroups: [NamedAPIResource]
    let growthRate: NamedAPIResource
    let isLegendary: Bool
    let isMythical: Bool
    let habitat: NamedAPIResource?
    let generation: NamedAPIResource

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case flavorTextEntries = "flavor_text_entries"
        case captureRate = "capture_rate"
        case baseHappiness = "base_happiness"
        case genderRate = "gender_rate"
        case eggGroups = "egg_groups"
        case growthRate = "growth_rate"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
        case habitat
        case generation
    }

    // MARK: - Helpers

    /// First English Pokédex entry, cleaned up.
    var englishFlavorText: String? {
        guard let entry = flavorTextEntries.first(where: { $0.language.name == "en" }) else {
            return nil
        }
        return entry.flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{000C}", with: " ")
    }

    /// Gender breakdown as a human-readable string.
    var genderDescription: String {
        if genderRate == -1 {
            return "Genderless"
        }
        let female = Double(genderRate) * 12.5
        let male = 100.0 - female
        return String(format: "♂ %.1f%% / ♀ %.1f%%", male, female)
    }

    var eggGroupNames: String {
        eggGroups.map { $0.name.capitalized }.joined(separator: ", ")
    }

    var growthRateName: String {
        growthRate.name.replacingOccurrences(of: "-", with: " ").capitalized
    }

    var generationName: String {
        generation.name.replacingOccurrences(of: "-", with: " ").capitalized
    }

    var habitatName: String? {
        habitat?.name.replacingOccurrences(of: "-", with: " ").capitalized
    }
}
