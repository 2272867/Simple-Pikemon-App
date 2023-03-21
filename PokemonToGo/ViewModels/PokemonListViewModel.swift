import Foundation

class PokemonListViewModel: ObservableObject {
   @Published var pokemonList: PokemonList = PokemonList(count: 20, next: "", previous: "", results: [])
   @Published var isLoading = false
   @Published var error: Error?
   
   private let pokemonService: PokemonServiceProtocol
   private var nextUrl: String?
   
   init(pokemonService: PokemonServiceProtocol = PokemonService()) {
       self.pokemonService = pokemonService
   }
   
    @MainActor func fetchPokemonList() {
       isLoading = true
       error = nil
       
       pokemonService.fetchPokemonList(url: nextUrl) { [weak self] result in
           DispatchQueue.main.async {
               guard let self = self else { return }
               self.isLoading = false
               
               switch result {
               case .success(let response):
                   self.nextUrl = response.next
                   self.pokemonList = response
               case .failure(let error):
                   self.error = error
               }
            
           }
       }
   }
}
