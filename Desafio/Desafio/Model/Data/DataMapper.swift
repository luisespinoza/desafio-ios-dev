//
//  DataMapper.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

import Foundation

final class DataMapper {
    static func registerTransformers() {
        ValueTransformer.setValueTransformer(
            StringArrayTransformer(),
            forName: NSValueTransformerName("StringArrayTransformer")
        )
    }
    
    func dataToEntity(_ value: PokemonDetailResponse, evolutions: [String]?, imageData: Data, entity: Pokemon) {
        entity.id = Int16(value.id)
        entity.name = value.name
        entity.types = value.types.map { $0.type.name } as NSArray
        entity.moves = value.moves.map { $0.move.name } as NSArray
        entity.evolutions = evolutions as? NSArray
        entity.height = Int16(value.height)
        entity.weight = Int16(value.weight)
        entity.image = imageData
    }
}
