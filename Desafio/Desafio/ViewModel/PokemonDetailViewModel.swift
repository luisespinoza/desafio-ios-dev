//
//  PokemonDetailViewModel.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//
import UIKit

final class PokemonDetailViewModel {
    private let pokemon: Pokemon
    var name: String { pokemon.name?.capitalized ?? "Unknown" }
    var image: UIImage? {
        if let imageData = pokemon.image {
            return UIImage(data: imageData)
        }
        return nil
    }
    var types: String {
        if let types = pokemon.types as? NSArray,
           types.count > 0 {
            return types.componentsJoined(by: ", ")
        }
        return "Unknown"
    }
    var moves: String {
        if let moves = pokemon.moves as? NSArray,
           moves.count > 0 {
            return moves.componentsJoined(by: ", ")
        }
        return "Unknown"
    }
    var evolutions: String {
        if let evolutions = pokemon.evolutions as? NSArray,
           evolutions.count > 0 {
            return evolutions.componentsJoined(by: ", ")
        }
        return "Unknown"
    }
    var height: String {
        // Decimeters to meters
        let meters = Double(pokemon.height) / 10.0
        return String(format: "%.1f m", meters)
    }
    
    var weight: String {
        // Hectograms to kilograms
        let kilograms = Double(pokemon.weight) / 10.0
        return String(format: "%.1f kg", kilograms)
    }
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
    }
}
