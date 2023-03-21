import Foundation
import SwiftUI

class PokemonDetailsViewModel: ObservableObject {
    @Published var pokemonDetails: PokemonDetails?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let pokemonService: PokemonServiceProtocol
    
    
    init(pokemonService: PokemonServiceProtocol = PokemonService()) {
        self.pokemonService = pokemonService

    }

func fetchPokemonDetails(id: Int) {
    isLoading = true
    error = nil
    
    pokemonService.fetchPokemonDetails(id: id) { result in
        DispatchQueue.main.async {
            self.isLoading = false
            switch result {
            case .success(let pokemonDetails):
                self.pokemonDetails = pokemonDetails
            case .failure(let error):
                self.error = error
            }
        }
    }
}
}
