//
//  ApiPokeURLBuilder.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

import Foundation

enum ApiPokeEndpoint {
    case pokemonList(limit: Int)
    case pokemonDetail(id: Int)
    case pokemonImage(id: Int)
    case species(id: Int)
    
    fileprivate var scheme: String { "https" }
    fileprivate var host: String {
        switch self {
        case .pokemonImage:
            return "raw.githubusercontent.com"
        default:
            return "pokeapi.co"
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .pokemonList:
            return "/api/v2/pokemon"
        case .pokemonDetail(let id):
            return "/api/v2/pokemon/\(id)"
        case .pokemonImage(let id):
            return "/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
        case .species(let id):
            return "/api/v2/pokemon-species/\(id)"
        }
    }
    
    fileprivate var queryItems: [URLQueryItem]? {
        switch self {
        case .pokemonList(let limit):
            return [URLQueryItem(name: "limit", value: String(limit))]
        default:
            return nil
        }
    }
}

final class ApiPokeURLBuilder {
    static func url(for endpoint: ApiPokeEndpoint) -> URL? {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        return components.url
    }
    
    static func url(from urlString: String) -> URL? {
        guard let components = URLComponents(string: urlString) else {
            return nil
        }
        return components.url
    }
}
