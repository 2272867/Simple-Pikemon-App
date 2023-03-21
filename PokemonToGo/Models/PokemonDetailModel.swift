import Foundation

struct PokemonDetails: Codable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let weight: Int
    let height: Int
    
    var imageUrl: URL {
        let number = String(format: "%03d", id)
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png")!
    }
}

struct PokemonType: Codable, Identifiable {
    var id = UUID()
    let slot: Int
    let type: Type
}

struct Type: Codable {
    let name: String
    let url: String
}
