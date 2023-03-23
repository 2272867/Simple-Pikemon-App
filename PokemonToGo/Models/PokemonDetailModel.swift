import Foundation
import SwiftUI
import Combine

struct PokemonDetails: Codable, Identifiable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let types: [PokemonTypes]
    
    var imageUrl: URL {
        let number = self.id
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png")!
    }
}

struct PokemonTypes: Codable {
    let type: PokemonNames
}

struct PokemonNames: Codable {
    let name: String
}
