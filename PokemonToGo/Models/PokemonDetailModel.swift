import Foundation

struct PokemonDetails: Codable {
    let name: String
    let weight: Int
    let height: Int
    let types: [PokemonTypes]
   // let srpites: Sprites
    

//    var imageUrl: URL {
//        let number = String.self
//        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png")
//    }
}
struct Sprites: Codable {
    let frontDefaultImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefaultImageURL = "front_default"
    }
}

struct PokemonTypes: Codable {
    let type: PokemonNames
}

struct PokemonNames: Codable {
    let name: String
}
