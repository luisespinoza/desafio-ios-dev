//
//  CacheManagerImpl.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

import CoreData

final class CacheManagerImpl: CacheManager {
    private let fetchDelay: TimeInterval = 0.1
    private let persistentContainer: NSPersistentContainer
    private let cacheSize: Int
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        return context
    }()
    
    init(
        persistentContainer: NSPersistentContainer,
        cacheSize: Int
    ) {
        self.persistentContainer = persistentContainer
        self.cacheSize = cacheSize
    }

    func isReady() -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = cacheSize
        do {
            let count = try context.count(for: fetchRequest)
            return count == cacheSize
        } catch {
            print("Failed to fetch data: \(error)")
            return false
        }
    }
    
    func cache(onComplete: @escaping (Result<Void, CacheError>) -> Void) {
        fetchPokemonList { [weak self] result in
            guard let list = result?.results else {
                onComplete(.failure(.noResults))
                return
            }
            self?.fetchPokemons(from: list)
        }
    }
    
    func cachedPokemons(onComplete: @escaping (Result<[Pokemon], CacheError>) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = cacheSize
        do {
            let pokemons = try context.fetch(fetchRequest)
            onComplete(.success(pokemons))
        } catch {
            print("Failed to fetch data: \(error)")
            onComplete(.failure(.cannotLoad))
        }
    }
    
    private func fetchPokemonList(completion: @escaping (PokemonListResponse?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(cacheSize)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                completion(response)
            } catch {
                print("Failed to decode data: \(error)")
                completion(nil)
            }
            
        }.resume()
    }
    
    private func fetchPokemons(from list: [PokemonListItem]) {
        let dispatchGroup = DispatchGroup()
        for (index, pokemonData) in list.enumerated() {
            let delay = Double(index) * fetchDelay
            dispatchGroup.enter()
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.fetchPokemon(from: pokemonData.url) { result in
                    dispatchGroup.leave()
                    print(result)
                }
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            do {
                try self?.backgroundContext.save()
            } catch {
                print("Failed to save data: \(error)")
            }
        }
    }
    
    private func fetchPokemon(from url: String, completion: @escaping (Result<Pokemon, CacheError>) -> Void) {
        let mapper = DataMapper()
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self else { return }
            guard let data = data else {
                completion(.failure(.noResults))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PokemonDetailResponse.self, from: data)
                let pokemonEntity = Pokemon(context: self.backgroundContext)
                mapper.dataToEntity(response, entity: pokemonEntity)
                completion(.success(pokemonEntity))
            } catch {
                print("Failed to decode data: \(error)")
                completion(.failure(.parsingError))
            }
        }.resume()
    }
}
