//
//  PokemonListViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

final class PokemonListViewModel {
    let cacheManager: CacheManager
    var isLoading: ((Bool) -> Void)?
    
    init(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }
    
    func onViewDidLoad() {
        if !cacheManager.isReady() {
            isLoading?(true)
            cacheManager.cache { [weak self] result in
                self?.isLoading?(false)
            }
        }
    }
}
