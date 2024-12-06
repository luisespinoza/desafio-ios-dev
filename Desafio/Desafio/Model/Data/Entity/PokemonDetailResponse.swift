//
//  PokemonDetailResponse.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
//    let abilities: [Ability]
    let types: [ApiPokemonTypeListItem]
//    let sprites: Sprites
}
