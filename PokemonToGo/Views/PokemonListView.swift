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
        ScrollView {
                LazyVStack {
                    ForEach(viewModel.pokemonList.results) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemonId: self.getPokemonIndex(pokemon: pokemon))) {
                            HStack {
                                VStack {
                                    Text(pokemon.name.capitalized)
                                        .font(.title)
                                        .foregroundColor(.black)
                                }
                                .frame(width: UIScreen.main.bounds.width - 20, height: 44)
                                .background(Color.gray.opacity(0.7))
                                .cornerRadius(20)
                            }
                        }.onAppear {
                            viewModel.fetchPokemonList()
                        }

                    }
                }
                .navigationBarTitle("Pokemon List")
                .onAppear {
                    viewModel.fetchPokemonList()
                }
        }

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
