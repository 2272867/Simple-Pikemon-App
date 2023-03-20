import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let strites: [String: String]
    let type: [Type]
    
    struct `Type`: Decodable {
        let type: TypeDetail
        
        struct TypeDetail: Decodable {
            let name: String
        }
    }
}
