import SwiftUI
import Combine

struct PokemonDetailView: View {
    @StateObject var viewModel = PokemonDetailsViewModel()
    let pokemonId: Int
    
    var body: some View {
        ZStack {
            Image("pokedexBackground2")
                .resizable()
                .ignoresSafeArea()
            VStack {
                if viewModel.isLoading {
                    Text("Loading...")
                    ProgressView()
                } else if let error = viewModel.error {
                    Text(error.localizedDescription)
                } else if let pokemon = viewModel.pokemonDetails {
                    VStack {
                        
                        URLImage(url: pokemon.imageUrl)
                            .frame(width: 200, height: 200)
                            .background(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center))
                        
                        
                        Text(pokemon.name.capitalized)
                            .font(.title)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width - 20, height: 70)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(20)
                        
                        HStack {
                            Text("Types: \(pokemon.types.map { $0.type.name.capitalized }.joined(separator: ", "))")
                                .frame(width: UIScreen.main.bounds.width - 20, height: 70)
                                .background(Color.green.opacity(0.7))
                                .cornerRadius(20)
                        }
                        .padding()
                        HStack {
                            VStack {
                                Text("Height:\n \(pokemon.height * 10) cm")
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 70)
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(20)
                            
                            
                            VStack {
                                Text("Weight:\n \(pokemon.weight / 10) kg")
                            }
                            .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 70)
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(20)
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
}



struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(pokemonId: 1)
    }
}
