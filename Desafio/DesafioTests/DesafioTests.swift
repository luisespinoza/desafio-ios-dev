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
        let dataManager = MockDataManager(cacheState: .notReady)
        let pokemonsViewModel = PokemonsViewModel(dataManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertTrue(dataManager.isCacheReadyCalled)
    }
    
    func testPokemonsViewModelCallsToCachePokemons() throws {
        // Given
        let dataManager = MockDataManager(cacheState: .notReady)
        let pokemonsViewModel = PokemonsViewModel(dataManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertTrue(dataManager.cacheCalled)
    }
    
    func testPokemonsViewModelDoesNotCallToCachePokemons() throws {
        // Given
        let dataManager = MockDataManager(cacheState: .ready)
        let pokemonsViewModel = PokemonsViewModel(dataManager: dataManager)
        
        // When
        pokemonsViewModel.onViewDidLoad()
        
        // Then
        XCTAssertFalse(dataManager.cacheCalled)
    }
}
