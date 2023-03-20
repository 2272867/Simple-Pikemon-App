import SwiftUI

struct PokemonListView: View {
    @ObservedObject var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.pokemons, id: \.name) { pokemon in
                NavigationLink(destination: PokemonDetailView(viewModel: PokemonDetailViewModel(id: pokemon.id))) {
                    Text(pokemon.name.capitalized)
                }
            }
            .navigationTitle("Pokemon List")
            .onAppear {
                viewModel.fetchPokemonList() }
            .overlay( Group {
                if viewModel.isLoading {
                    ProgressView()
                }
                if let error = viewModel.error {
                    VStack {
                        Text("Error loading data")
                        Text(error.localizedDescription)
                    }
                }
            })
            
        }
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
