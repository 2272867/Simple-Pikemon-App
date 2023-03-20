import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonListItem
    
    var body: some View {
        VStack {
            PokemonListView(pokemon: pokemon)
            
            VStack() {

            }
          
        }

        }
    }
}
//
//struct PokemonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PokemonDetailView(pokemon: PokemonListItem.samplePokemon)
//            .environmentObject(ViewModel())
//    }
//}
