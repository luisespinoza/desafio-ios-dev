//
//  ApiChain.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

struct ApiChain: Codable {
    let species: ApiSpecies
    let evolvesTo: [ApiChain]
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }
}
