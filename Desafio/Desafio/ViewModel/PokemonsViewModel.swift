//
//  PokemonsViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

final class PokemonsViewModel {
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
    let dataManager: CacheManager
    var isLoading = false
    
    init(dataManager: CacheManager) {
        self.dataManager = dataManager
    }
    
    func onViewDidLoad() {
        if !dataManager.isReady() {
            isLoading = true
            dataManager.cache { [weak self] result in
                self?.isLoading = false
            }
        }
    }
}
