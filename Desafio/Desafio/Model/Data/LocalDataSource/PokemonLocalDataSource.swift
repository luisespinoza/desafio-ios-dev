//
//  PokemonLocalDataSource.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

protocol PokemonLocalDataSource {
    func pokemons() -> [Pokemon]?
    func savePokemons(_ pokemons: [Pokemon])
}
