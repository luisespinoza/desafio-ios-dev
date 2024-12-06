//
//  PokemonRemoteDataSourceImpl.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 06-12-24.
//

import Foundation

final class PokemonRemoteDataSourceImpl: PokemonRemoteDataSource {
    func fetchPokemonList(count: Int, completion: @escaping (ApiPokemonListResponse?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(count)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ApiPokemonListResponse.self, from: data)
                completion(response)
            } catch {
                print("Failed to decode data: \(error)")
                completion(nil)
            }
            
        }.resume()
    }
    
    func fetchPokemon(from url: String, completion: @escaping (Result<ApiPokemonDetailResponse, ApiError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                var response = try JSONDecoder().decode(ApiPokemonDetailResponse.self, from: data)
                var error: ApiError? = nil
                
                let pokemonDispatchGroup = DispatchGroup()
                pokemonDispatchGroup.notify(queue: .main) {
                    guard error == nil else {
                        completion(.failure(error!))
                        return
                    }
                    completion(.success((response)))
                }
                
                pokemonDispatchGroup.enter()
                self.fetchPokemonImage(
                    pokemonID: response.id
                ) { result in
                    switch result {
                    case .success(let data):
                        response.imageData = data
                    case .failure(let networkError):
                        error = networkError
                    }
                    pokemonDispatchGroup.leave()
                }
                
                pokemonDispatchGroup.enter()
                self.fetchPokemonEvolutions(
                    pokemonID: response.id,
                    speciesURL: response.species.url
                ) { result in
                    switch result {
                    case .success(let data):
                        response.evolutions = data
                    case .failure(let networkError):
                        error = networkError
                    }
                    pokemonDispatchGroup.leave()
                }
            } catch {
                print("Failed to decode data: \(error)")
                completion(.failure(.invalidData))
            }
        }.resume()
    }
    
    func fetchPokemonImage(pokemonID: Int, completion: @escaping (Result<Data, ApiError>) -> Void) {
        let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png"
        guard let url = URL(string: imageUrlString) else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchPokemonEvolutions(pokemonID: Int, speciesURL: String, completion: @escaping (Result<[String], ApiError>) -> Void) {
        guard let speciesURL = URL(string: speciesURL) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: speciesURL) { data, _, _ in
            guard let data = data,
                  let speciesResponse = try? JSONDecoder().decode(ApiSpeciesResponse.self, from: data) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let url = URL(string: speciesResponse.evolutionChain.url) else {
                completion(.failure(.invalidURL))
                return
            }
            URLSession.shared.dataTask(with: url) {[weak self] data, _, _ in
                guard let self else { return }
                guard let data = data,
                      let evolutionChain = try? JSONDecoder().decode(ApiEvolutionChain.self, from: data)
                else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                var evolutions: [String] = []
                self.processEvolutionChain(evolutionChain.chain, evolutions: &evolutions)
                completion(.success(evolutions))
            }.resume()
        }.resume()
    }
    
    private func processEvolutionChain(_ chain: ApiChain, evolutions: inout [String]) {
        evolutions.append(chain.species.name)
        
        for evolution in chain.evolvesTo {
            processEvolutionChain(evolution, evolutions: &evolutions)
        }
    }
}
