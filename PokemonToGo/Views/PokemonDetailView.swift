import SwiftUI
import Combine
import SDWebImageSwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel = PokemonDetailsViewModel()
    let pokemonId: Int
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
            } else if let pokemon = viewModel.pokemonDetails {
                VStack {
                   // URLImage(url: pokemon.imageUrl)
                    AnimatedImage(url: pokemon.imageUrl)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    Text(pokemon.name.capitalized)
                        .font(.title)
                        .padding()
                    HStack {
                        Text("Type:")
                        ForEach(pokemon.types) { type in
                            Text(type.type.name)
                        }
                    }
                    .padding()
                    HStack {
                        Text("Weight:")
                        Text("\(pokemon.weight) kg")
                    }
                    .padding()
                    HStack {
                        Text("Height:")
                        Text("\(pokemon.height) m")
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.fetchPokemonDetails(id: pokemonId)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemonId: 1)
    }
}
