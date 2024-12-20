//
//  DesafioTests.swift
//  DesafioTests
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

import XCTest
@testable import Desafio

final class DesafioTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPokemonsViewModelChecksIfCacheIsReady() throws {
        // Given
        let dataManager = MockDataManager(state: .notReady)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertTrue(dataManager.isCacheReadyCalled)
    }
    
    func testPokemonsViewModelCallsToCachePokemons() throws {
        // Given
        let dataManager = MockDataManager(state: .notReady)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertTrue(dataManager.cacheCalled)
    }
        
    func testPokemonsViewModelDoesNotCallToCachePokemons() throws {
        // Given
        let dataManager = MockDataManager(state: .ready)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertFalse(dataManager.cacheCalled)
    }
    
    func testPokemonsViewModelIsLoadingWhenCache() throws {
        // Given
        let dataManager = MockDataManager(state: .notReady)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        var isLoading = false
        pokemonsViewModel.isLoading = { loading in
            isLoading = loading
        }
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertTrue(isLoading)
    }
    
    func testPokemonsViewModelNotLoadingWhenReady() throws {
        // Given
        let dataManager = MockDataManager(state: .ready)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        var isLoading = true
        pokemonsViewModel.isLoading = { loading in
            isLoading = loading
        }
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertFalse(isLoading)
    }
    
    func testPokemonsViewModelEndsLoadingOnSuccess() throws {
        // Given
        let dataManager = MockDataManager(state: .notReady, result: .success)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        let expectation = self.expectation(description: "Loading completes")
        var isLoading = true
        pokemonsViewModel.isLoading = { loading in
            isLoading = loading
        }
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertFalse(isLoading)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
    
    func testPokemonsViewModelEndsLoadingOnFailure() throws {
        // Given
        let dataManager = MockDataManager(state: .notReady, result: .failure)
        let pokemonsViewModel = PokemonListViewModel(cacheManager: dataManager)
        let expectation = self.expectation(description: "Loading completes")
        var isLoading = true
        pokemonsViewModel.isLoading = { loading in
            isLoading = loading
        }
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertFalse(isLoading)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
