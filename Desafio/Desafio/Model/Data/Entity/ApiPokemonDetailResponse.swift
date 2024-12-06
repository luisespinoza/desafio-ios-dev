//
//  ApiPokemonDetailResponse.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//
import Foundation

struct ApiPokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let moves: [ApiMoveListItem]
    let types: [ApiPokemonTypeListItem]
    let species: ApiSpecies
    var imageData: Data?
    var evolutions: [String]?
}
