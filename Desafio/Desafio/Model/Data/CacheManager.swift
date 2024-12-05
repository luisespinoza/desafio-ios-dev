//
//  CacheManager.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

enum CacheError: Error {
    case unreacheable
    case cannotSave
    case cannotLoad
}

protocol CacheManager {
    func isReady() -> Bool
    func cache(onComplete: @escaping (Result<Void, CacheError>) -> Void)
}
