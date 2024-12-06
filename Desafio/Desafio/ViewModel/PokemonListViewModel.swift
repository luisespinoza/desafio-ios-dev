//
//  PokemonListViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

protocol PokemonListViewModelDelegate: AnyObject {
    func pokemonListViewModel(_ viewModel: PokemonListViewModel, didSelectPokemon: Pokemon)
}

final class PokemonListViewModel {
    let cacheManager: CacheManager
    var isLoading: ((Bool) -> Void)?
    var pokemons: (([Pokemon]) -> Void)?
    weak var delegate: PokemonListViewModelDelegate?
    
    init(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }
    
    func onViewDidLoad() {
        if cacheManager.isReady() {
            isLoading?(false)
            loadPokemons()
        } else {
            isLoading?(true)
            cacheManager.cache { [weak self] _ in
                guard let self else { return }
                self.loadPokemons()
                self.isLoading?(false)
            }
        }
    }
    
    func didSelectPokemon(at index: Int) {
        if let pokemonList = cacheManager.pokemons(), index < pokemonList.count {
            let selectedPokemon = pokemonList[index]
            delegate?.pokemonListViewModel(self, didSelectPokemon: selectedPokemon)
        }
    }
    
    func cellModelForRow(at index: Int) -> PokemonListCellModel? {
        if let pokemonList = cacheManager.pokemons(), index < pokemonList.count {
            let pokemon = pokemonList[index]
            return PokemonListCellModel(pokemon: pokemon)
        }
        return nil
    }
    
    private func loadPokemons() {
        if let pokemonList = cacheManager.pokemons() {
            pokemons?(pokemonList)
        }
    }
}
