import XCTest
@testable import PokemonToGo

class PokemonServiceTests: XCTestCase {
    
    var pokemonService: PokemonService!
    
    override func setUp() {
        super.setUp()
        pokemonService = PokemonService()
    }
    
    override func tearDown() {
        pokemonService = nil
        super.tearDown()
    }
    
    func testFetchPokemonListWithValidURL() {
        let expectation = XCTestExpectation(description: "Fetch pokemon list with valid URL")
        
        pokemonService.fetchPokemonList(url: nil) { result in
            switch result {
            case .success(let pokemonList):
                XCTAssertFalse(pokemonList.results.isEmpty, "Pokemon list should not be empty")
            case .failure(let error):
                XCTFail("Error fetching pokemon list: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchPokemonListWithInvalidURL() {
        let expectation = XCTestExpectation(description: "Fetch pokemon list with invalid URL")
        
        pokemonService.fetchPokemonList(url: "invalidURL") { result in
            switch result {
            case .success(_):
                XCTFail("Should not succeed with invalid URL")
            case .failure(let error):
                XCTAssertEqual(error as? APIError, APIError.invalidURL, "Invalid error type")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchPokemonDetailsWithValidID() {
        let expectation = XCTestExpectation(description: "Fetch pokemon details with valid ID")
        
        pokemonService.fetchPokemonDetails(id: 1) { result in
            switch result {
            case .success(let pokemonDetails):
                XCTAssertEqual(pokemonDetails.id, 1, "Should return pokemon with ID 1")
            case .failure(let error):
                XCTFail("Error fetching pokemon details: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testFetchPokemonDetailsWithInvalidID() {
        let expectation = XCTestExpectation(description: "Fetch pokemon details with invalid ID")
        
        pokemonService.fetchPokemonDetails(id: -1) { result in
            switch result {
            case .success(_):
                XCTFail("Should not succeed with invalid ID")
            case .failure(let error):
                XCTAssertEqual(error as? APIError, APIError.noData, "Invalid error type")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
