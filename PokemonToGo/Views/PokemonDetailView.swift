import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    
    var body: some View {
        VStack {
            if let pokemonDetail = viewModel.pokemonDetail {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding()
                Text(pokemonDetail.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Height: \(pokemonDetail.height)")
                Text("Weight: \(pokemonDetail.weight)")
                
                HStack {
                    ForEach(pokemonDetail.type, id: \.type.name) { type in Text(type.type.name.capitalized)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Pokemon Detail")
        .onAppear {
            viewModel.fetchPokemonDetail()}
        .overlay(
            Group {
                if viewModel.isLoading {
                    ProgressView()
                }
                if let error = viewModel.error {
                    VStack {
                        Text("Error loading data")
                        Text(error.localizedDescription)
                    }
                }
            }
        )
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(viewModel: PokemonDetailViewModel(id: 1))
    }
}
