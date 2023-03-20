import Foundation
import Combine

class PokemonService {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPokemonList(offset: Int = 0, limit: Int = 20) -> AnyPublisher<[Pokemon], Error> {
        let url = baseURL!.appendingPathComponent("pokemon")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name:"offset", value: "\(offset)"),
            URLQueryItem(name:"limit", value: "\(limit)")
        ]
        
        let request = URLRequest(url: components.url!)
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PokemonListResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        let url = baseURL!.appendingPathComponent("pokemon/\(id)")
        let request = URLRequest(url: url)
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private struct PokemonListResponse: Decodable {
        let results: [Pokemon]
    }
}
