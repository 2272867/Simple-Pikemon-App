import Foundation
import SwiftUI
import Combine
import Network

enum APIError: Error {
    case noData
    case invalidURL
    case serverError(String)
}

protocol PokemonServiceProtocol {
    func fetchPokemonList(url: String?, completion: @escaping (Result<PokemonList, Error>) -> Void)
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<PokemonDetails, Error>) -> Void)
}

final class PokemonService: PokemonServiceProtocol {
    private let queue = DispatchQueue(label: "Pokemon.WebService", qos: .background, attributes: .concurrent)
    private let baseUrl = "https://pokeapi.co/api/v2/pokemon/"
    private let monitor = NWPathMonitor()
    var isInternetAvailable: Bool = false
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isInternetAvailable = true
            } else {
                self.isInternetAvailable = false
            }
        }
        let queue = DispatchQueue(label: "Monitor", qos: .background, attributes: .concurrent)
        monitor.start(queue: queue)
    }
    
    func fetchPokemonList(url: String?, completion: @escaping (Result<PokemonList, Error>) -> Void) {
        let url = url ?? baseUrl
        
        if let cachedData = CacheService.shared.object(forKey: url) as? Data,
           let pokemonList = try? JSONDecoder().decode(PokemonList.self, from: cachedData) {
            completion(.success(pokemonList))
            return
        }
        if !isInternetAvailable {
            let message = "Only pokemon that have already been viewed will be available for viewing."
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No internet connection", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        queue.async {
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
                    CacheService.shared.setObject(data as AnyObject, forKey: url)
                    completion(.success(pokemonList))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
        
    }
    
    func fetchPokemonDetails(id: Int, completion: @escaping (Result<PokemonDetails, Error>) -> Void) {
        let url = "\(baseUrl)\(id)"
        
        if let cachedData = CacheService.shared.object(forKey: url) as? Data,
           let PokemonDetails = try? JSONDecoder().decode(PokemonDetails.self, from: cachedData) {
            completion(.success(PokemonDetails))
            return
        }
        
        queue.async {
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
                    CacheService.shared.setObject(data as AnyObject, forKey: url)
                    completion(.success(pokemonDetails))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}


