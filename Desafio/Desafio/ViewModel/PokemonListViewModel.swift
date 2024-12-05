//
//  PokemonListViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

final class PokemonListViewModel {
//    @Published var pokemons: [Pokemon] = []
//    
//    init() {
//        fetchPokemons()
//    }
//    
//    private func fetchPokemons() {
//        PokemonService.fetchPokemons { result in
//            switch result {
//                
//            }
//        }
//    }
    let cacheManager: CacheManager
    var isLoading = false
    
    init(dataManager: CacheManager) {
        self.cacheManager = dataManager
    }
    
    func onViewDidLoad() {
        if !cacheManager.isReady() {
            isLoading = true
            cacheManager.cache { [weak self] result in
                self?.isLoading = false
            }
        }
    }
}
