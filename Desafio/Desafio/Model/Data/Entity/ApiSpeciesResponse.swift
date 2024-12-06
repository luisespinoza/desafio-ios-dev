//
//  ApiSpeciesResponse.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

struct ApiSpeciesResponse: Codable {
    let evolutionChain: ApiSpeciesEvolutionChain
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}
