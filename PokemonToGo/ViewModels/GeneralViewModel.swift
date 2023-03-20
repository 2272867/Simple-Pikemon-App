import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    private let pokemonSrvice = PokemonService()
    
    @Published var pokemonList = [PokemonListItem]()
    @Published var pokemonDetails: PokemonDetail?
    @Published var searchText = ""
    
   
    var filteredPokemon: [PokemonListItem] {
                return searchText == "" ? pokemonList : pokemonList.filter { $0.name.contains(searchText.lowercased()) }
            }
    
    init() {
        self.pokemonList = pokemonSrvice.getPokemonList()
    }
    
    func getPokemonIndex(pokemon: PokemonListItem) -> Int {
        if let index = self.pokemonList.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    func getDetails(pokemon: PokemonListItem) {
        let id = getPokemonIndex(pokemon: pokemon)
        
        self.pokemonDetails = PokemonDetail(id: 0, height: 0, weight: 0)
        
        pokemonSrvice.getDetailedPokemon(id: id) { data in
            DispatchQueue.main.async {
                self.pokemonDetails = data
            }
        }
    }
    
    func formatHW(value: Int) -> String {
        let dValue = Double(value)
        let string = String(format: "%.2f", dValue / 10)
        
        return string
    }
}
