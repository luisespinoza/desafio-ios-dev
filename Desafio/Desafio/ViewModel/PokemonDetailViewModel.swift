//
//  PokemonDetailViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//
import UIKit

final class PokemonDetailViewModel {
    private let pokemon: Pokemon
    var name: String { pokemon.name ?? "Unknown" }
    var image: UIImage? {
        if let imageData = pokemon.image {
            return UIImage(data: imageData)
        }
        return nil
    }
    var type: String { pokemon.type ?? "Unknown" }
    var height: String { "\(pokemon.height) m" }
    var weight: String { "\(pokemon.weight) kg" }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
