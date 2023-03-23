import Foundation
import SwiftUI
import Combine

final class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: PokemonList = PokemonList(count: 0, next: nil, previous: nil, results: [])
    @Published var isLoading = false
    @Published var error: Error?
    
    
    private let pokemonService: PokemonServiceProtocol
    private var currentPage = 0
    private var nextUrl: String?
    
    init(pokemonService: PokemonServiceProtocol = PokemonService()) {
        self.pokemonService = pokemonService
    }
    
    func fetchPokemonList() {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        
        let limit = 15
        let offset = currentPage * limit
        let url = "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)"
        
        
        pokemonService.fetchPokemonList(url: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.pokemonList.count = response.count
                    self.pokemonList.next = response.next
                    self.pokemonList.previous = response.previous
                    
                    if self.currentPage == 0 {
                        self.pokemonList.results = response.results
                    } else {
                        self.pokemonList.results.append(contentsOf: response.results)
                    }
                    self.currentPage += 1
                case .failure(let error):
                    self.error = error
                }
                
            }
        }
    }
}
