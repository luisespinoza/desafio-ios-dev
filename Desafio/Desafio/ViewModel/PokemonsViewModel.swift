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
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func onViewDidLoad() {
        if dataManager.isCacheReady() {
            
        }
    }
}
