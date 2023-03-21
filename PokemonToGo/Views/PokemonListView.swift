import SwiftUI
import SDWebImageSwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                } else if viewModel.pokemonList.isEmpty {
                    Text("No Pokemon Found")
                } else {
                    List {
                        ForEach(viewModel.pokemonList) { pokemon in
                            NavigationLink(destination: PokemonDetailView(pokemonId: pokemon.id)) {
                                HStack {
                                  //  URLImage(url: pokemon.imageUrl)
                                    AnimatedImage(url: URL(string: pokemon.url))
                                        .frame(width: 50, height: 50)
                                    Text(pokemon.name.capitalized)
                                }
                            }
                            .onAppear {
                                if viewModel.pokemonList.isLastItem(pokemon) {
                                    viewModel.fetchPokemonList()
                                }
                            }
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
        guard let lastItem = self.last else { return false }
        return item.id == lastItem.id
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
