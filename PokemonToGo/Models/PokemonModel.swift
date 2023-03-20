import Foundation

struct PokemonList: Codable {
    let count: Int
    let next: String
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable, Equatable {
    var id = UUID()
    let name: String
    let url: String
    
    static var samplePokemon = PokemonListItem(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
}

struct PokemonDetail: Codable {
    let id: Int
    let height: Int
    let weight: Int
}
