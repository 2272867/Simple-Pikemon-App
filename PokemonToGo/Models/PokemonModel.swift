import Foundation

struct PokemonList: Codable {
    let count: Int
    let next: String
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String
    
}
