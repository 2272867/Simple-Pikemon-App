import Foundation
import SwiftUI
import Combine

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var currentPage = 0
    
    func getPokemonIndex(pokemon: PokemonListItem) -> Int {
        if let index = viewModel.pokemonList.results.firstIndex(of: pokemon) {
            return index + 1
        }
        return 0
    }
    
    var body: some View {
        NavigationView {
                List {
                    ForEach(viewModel.pokemonList.results) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonId: self.getPokemonIndex(pokemon: pokemon))) {
                            HStack {
                                Text(pokemon.name.capitalized)
                                    .frame(height: 44)
                            }
                        }
                        .onAppear {
                            if viewModel.pokemonList.results.isLastItem(pokemon) {
                                viewModel.fetchPokemonList()
                            }
                        }
                    }
                }
                .navigationBarTitle("Pokemon List")
                
        }
        .onAppear {
            viewModel.fetchPokemonList()
        }
    }
}

extension Array where Element == PokemonListItem {
    func isLastItem(_ item: Element) -> Bool {
        guard self.last != nil else { return true }
      //  return item.id == lastItem.id
        return false
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
