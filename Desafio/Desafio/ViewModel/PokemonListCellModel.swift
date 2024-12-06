//
//  PokemonListCellModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//
import UIKit

final class PokemonListCellModel {
    let pokemon: Pokemon
    var name: String? { pokemon.name?.capitalized }
    var image: UIImage? {
        if let imageData = pokemon.image {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
