//
//  CacheManagerImpl.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

import CoreData

final class CacheManagerImpl: CacheManager {
    private let fetchDelay: TimeInterval = 0.2
    private let persistentContainer: NSPersistentContainer
    private let cacheSize: Int
    private var cachedPokemons: [Pokemon]?
    
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
            self?.fetchPokemons(from: list, completion: onComplete)
        }
    }
    
    func pokemons() -> [Pokemon]? {
        if let cachedPokemons = cachedPokemons {
            return cachedPokemons
        }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.fetchLimit = cacheSize
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let pokemons = try context.fetch(fetchRequest)
            cachedPokemons = pokemons
            return pokemons
        } catch {
            print("Failed to fetch data: \(error)")
            return nil
        }
    }
    
    private func fetchPokemonList(completion: @escaping (ApiPokemonListResponse?) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(cacheSize)")!
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
    
    private func fetchPokemons(from list: [ApiPokemonListItem], index: Int = 0, completion: @escaping (Result<Void, CacheError>) -> Void) {
        guard index < list.count else {
            do {
                try self.backgroundContext.save()
                print("Saved data")
                completion(.success(()))
            } catch {
                print("Failed to save data: \(error)")
                completion(.failure(.cannotSave))
            }
            return
        }
        let pokemonData = list[index]
        fetchPokemon(from: pokemonData.url) { [weak self] result in
            self?.fetchPokemons(from: list, index: index + 1, completion: completion)
        }
    }
    
    private func fetchPokemon(from url: String, completion: @escaping (Result<Void, CacheError>) -> Void) {
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
                let response = try JSONDecoder().decode(ApiPokemonDetailResponse.self, from: data)
                self.backgroundContext.performAndWait { [weak self] in
                    guard let self else { return }
                    let pokemonEntity = Pokemon(context: self.backgroundContext)
                    let mapper = DataMapper()
                    mapper.dataToEntity(
                        response,
                        entity: pokemonEntity
                    )
                }
                
                let pokemonDispatchGroup = DispatchGroup()
                pokemonDispatchGroup.notify(queue: .main) {
                    completion(.success(()))
                }
                
                pokemonDispatchGroup.enter()
                self.fetchPokemonImage(
                    pokemonID: response.id
                ) { _ in
                    pokemonDispatchGroup.leave()
                }
                
                pokemonDispatchGroup.enter()
                self.fetchPokemonEvolutions(
                    pokemonID: response.id,
                    speciesURL: response.species.url
                ) { _ in
                    pokemonDispatchGroup.leave()
                }
            } catch {
                print("Failed to decode data: \(error)")
                completion(.failure(.parsingError))
            }
        }.resume()
    }
    
    private func fetchPokemonImage(pokemonID: Int, completion: @escaping (Result<Void, CacheError>) -> Void) {
        let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png"
        guard let url = URL(string: imageUrlString) else {
            completion(.failure(.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            self?.fetchPokemon(by: pokemonID) { result in
                switch result {
                case .success(let pokemon):
                    pokemon.image = data
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchPokemonEvolutions(pokemonID: Int, speciesURL: String, completion: @escaping (Result<Void, CacheError>) -> Void) {
        guard let speciesURL = URL(string: speciesURL) else {
            completion(.failure(.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: speciesURL) { data, _, _ in
            guard let data = data,
                  let speciesResponse = try? JSONDecoder().decode(ApiSpeciesResponse.self, from: data) else {
                completion(.failure(.parsingError))
                return
            }
            
            guard let url = URL(string: speciesResponse.evolutionChain.url) else {
                completion(.failure(.invalidUrl))
                return
            }
            URLSession.shared.dataTask(with: url) {[weak self] data, _, _ in
                guard let self else { return }
                guard let data = data,
                      let evolutionChain = try? JSONDecoder().decode(ApiEvolutionChain.self, from: data)
                else {
                    completion(.failure(.parsingError))
                    return
                }
                
                var evolutions: [String] = []
                self.processEvolutionChain(evolutionChain.chain, evolutions: &evolutions)
                
                self.fetchPokemon(by: pokemonID) { result in
                    switch result {
                    case .success(let pokemon):
                        pokemon.evolutions = evolutions as NSArray
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        }.resume()
    }
    
    private func fetchPokemon(by id: Int, completion: @escaping (Result<Pokemon, CacheError>) -> Void) {
         backgroundContext.performAndWait {
             let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
             fetchRequest.predicate = NSPredicate(format: "id == %d", id)
             fetchRequest.fetchLimit = 1
             
             do {
                 let results = try self.backgroundContext.fetch(fetchRequest)
                 if let pokemon = results.first {
                     completion(.success(pokemon))
                 } else {
                     completion(.failure(.noResults))
                 }
             } catch {
                 print("Failed to fetch pokemon: \(error)")
                 completion(.failure(.cannotLoad))
             }
         }
     }
    
    private func processEvolutionChain(_ chain: ApiChain, evolutions: inout [String]) {
        evolutions.append(chain.species.name)
        
        for evolution in chain.evolvesTo {
            processEvolutionChain(evolution, evolutions: &evolutions)
        }
    }
}
