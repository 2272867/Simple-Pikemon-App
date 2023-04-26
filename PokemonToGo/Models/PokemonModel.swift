import Foundation
import SwiftUI
import Combine

struct PokemonList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [PokemonListItem]
}

struct PokemonListItem: Codable, Identifiable, Equatable {
    let id: String?
    let name: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, url
    }
    init(id: String, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
