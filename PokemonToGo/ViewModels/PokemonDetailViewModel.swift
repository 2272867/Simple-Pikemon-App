import Foundation
import Combine
import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var subscription = Set <AnyCancellable>()
    private let pokemonService = PokemonService()
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func fetchPokemonDetail() {
        isLoading = true
        pokemonService.fetchPokemonDetail(id: id)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.error = error
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemonDetail in
                self?.pokemonDetail = pokemonDetail
            })
            .store(in: &subscription)
    }
}
