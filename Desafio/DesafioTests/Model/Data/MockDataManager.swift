//
//  MockDataManager.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//
@testable import Desafio

enum MockDataManagerCacheState {
    case ready
    case notReady
}

class MockDataManager: CacheManager {
    let cacheState: MockDataManagerCacheState

    var isCacheReadyCalled = false
    var cacheCalled = false

    init(cacheState: MockDataManagerCacheState) {
        self.cacheState = cacheState
    }
    
    func isReady() -> Bool {
        isCacheReadyCalled = true
        
        switch cacheState {
        case .ready:
            return true
        case .notReady:
            return false
        }
    }
    
    func cache() {
        cacheCalled = true
    }
}
