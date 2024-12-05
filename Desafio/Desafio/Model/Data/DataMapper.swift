//
//  DataMapper.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

final class DataMapper {
    func dataToEntity(_ value: PokemonDetailResponse, entity: Pokemon) {
        entity.id = Int16(value.id)
        entity.name = value.name
        entity.height = Int16(value.height)
        entity.weight = Int16(value.weight)
    }
}
