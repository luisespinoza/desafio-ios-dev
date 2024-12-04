//
//  MockDataManager.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//
@testable import Desafio
import Foundation

enum MockDataManagerCacheState {
    case ready
    case notReady
}

enum MockDataManagerCacheResult {
    case success
    case failure
}

class MockDataManager: CacheManager {
    let state: MockDataManagerCacheState
    let result: MockDataManagerCacheResult

    var isCacheReadyCalled = false
    var cacheCalled = false

    init(state: MockDataManagerCacheState, result: MockDataManagerCacheResult = .success) {
        self.state = state
        self.result = result
    }
    
    func isReady() -> Bool {
        isCacheReadyCalled = true
        
        switch state {
        case .ready:
            return true
        case .notReady:
            return false
        }
    }
    
    func cache(onComplete: @escaping (Result<Void, CacheError>) -> Void) {
        cacheCalled = true
        
        switch result {
        case .success:
            DispatchQueue.main.async {
                onComplete(.success(()))
            }
        case .failure:
            DispatchQueue.main.async {
                onComplete(.failure(.unreacheable))
            }
        }
    }
}
