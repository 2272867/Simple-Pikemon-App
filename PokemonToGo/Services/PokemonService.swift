import Foundation
import Combine

class PokemonService {
    func getPokemonList() -> [PokemonListItem] {
        let data: PokemonList = Bundle.main.decode(file:"pokemon.json")
        let pokemon: [PokemonListItem] = data.results
        
        return pokemon
    }
    
    func getDetailedPokemon(id: Int, _ completion:@escaping (PokemonDetail) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: PokemonDetail.self) { data in
            completion(data)
            print(data)
            
        } failure: { error in
            print(error)
        }
    }
}
