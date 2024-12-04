//
//  MockDataManager.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//
@testable import Desafio

class MockDataManager: DataManager {
    var isCacheReadyCalled: Bool = false
    
    func isCacheReady() -> Bool {
        isCacheReadyCalled = true
        return false
    }
}
