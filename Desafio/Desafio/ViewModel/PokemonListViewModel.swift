//
//  PokemonListViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

final class PokemonListViewModel {
    let cacheManager: CacheManager
    var isLoading: ((Bool) -> Void)?
    var pokemons: (([Pokemon]) -> Void)?
    
    init(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }
    
    func onViewDidLoad() {
        if cacheManager.isReady() {
            self.loadPokemons()
        } else {
            isLoading?(true)
            cacheManager.cache { [weak self] _ in
                guard let self else { return }
                self.loadPokemons()
                self.isLoading?(false)
            }
        }
    }
    
    private func loadPokemons() {
        cacheManager.pokemons { [weak self] result in
            switch result {
            case .success(let pokemons):
                self?.pokemons?(pokemons)
            case .failure(let error):
                print("Failed to load pokemons: \(error)")
            }
        }
    }
}
