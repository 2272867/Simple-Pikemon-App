import Foundation

struct PokemonList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case name, url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
    }
    
}
