//
//  PokemonRemoteDataSource.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//
import Foundation

enum ApiError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

protocol PokemonRemoteDataSource {
    func fetchPokemonList(count: Int, completion: @escaping (ApiPokemonListResponse?) -> Void)
    func fetchPokemon(from url: String, completion: @escaping (Result<ApiPokemonDetailResponse, ApiError>) -> Void)
    func fetchPokemonImage(pokemonID: Int, completion: @escaping (Result<Data, ApiError>) -> Void)
}
