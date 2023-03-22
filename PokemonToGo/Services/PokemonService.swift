import Foundation
import SwiftUI
import Combine

enum APIError: Error {
    case noData
    case invalidURL
    case serverError(String)
}

protocol PokemonServiceProtocol {
    func fetchPokemonList(url: String?, completion: @escaping (Result<PokemonList, Error>) -> Void)
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<PokemonDetails, Error>) -> Void)
}

class PokemonService: PokemonServiceProtocol {
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
    
    func fetchPokemonList(url: String?, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let url = url ?? baseUrl
        guard let requestUrl = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                completion(.success(pokemonList))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<PokemonDetails, Error>) -> Void) {
        let url = "\(baseUrl)\(id)"
        guard let requestUrl = URL(string: url) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(APIError.serverError("Server error: \(statusCode)")))
                return
            }
            
            do {
                let pokemonDetails = try JSONDecoder().decode(PokemonDetails.self, from: data)
                completion(.success(pokemonDetails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


