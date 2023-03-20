import Foundation
import Combine
import SwiftUI

class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    private let pokemonService = PokemonService()
    
    func fetchPokemonList() {
        isLoading = true
        pokemonService.fetchPokemonList()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error
                case . finished:
                    break
                }
            }, receiveValue: { [weak self] pokemons in
                self?.pokemons.append(contentsOf: pokemons)
            })
            .store(in: &subscriptions)
    }
}
