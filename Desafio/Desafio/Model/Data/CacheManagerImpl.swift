//
//  CacheManagerImpl.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

import CoreData

final class CacheManagerImpl: CacheManager {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func isReady() -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 151
        do {
            let count = try context.count(for: fetchRequest)
            return count == 151
        } catch {
            print("Failed to fetch data: \(error)")
            return false
        }
    }
    
    func cache(onComplete: @escaping (Result<Void, CacheError>) -> Void) {
        // fetch Pokemons
        fetchPokemons { result in
            print("Fetched pokemons: \(result?.results ?? [])")
        }
    }
    
    func cachedPokemons(onComplete: @escaping (Result<[Pokemon], CacheError>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = 151
        do {
            let pokemons = try context.fetch(fetchRequest)
            onComplete(.success(pokemons))
        } catch {
            print("Failed to fetch data: \(error)")
            onComplete(.failure(.cannotLoad))
        }
    }
    
    private func fetchPokemons(completion: @escaping (PokemonListResponse?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let response = try? JSONDecoder().decode([PokemonData].self, from: data)
            guard let response else {
                completion(nil)
                return
            }
            
            let pokemonListResponse = PokemonListResponse(results: response)
            completion(pokemonListResponse)
        }.resume()
    }
}
