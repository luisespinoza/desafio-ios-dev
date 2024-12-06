//
//  PokemonListViewController.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

import UIKit

class PokemonListViewController: UIViewController {
    var viewModel: PokemonListViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    private var pokemonList: [Pokemon] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadingView: PokemonListLoadingView = {
        let view = PokemonListLoadingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
        setupLoadingView()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    private func bindViewModel() {
        viewModel?.isLoading = { [weak self] isLoading in
            self?.loadingView.isHidden = !isLoading
        }
        viewModel?.pokemons = { [weak self] pokemons in
            self?.pokemonList = pokemons
            self?.tableView.reloadData()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title =  "Pokémon List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PokemonCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        let pokemon = pokemonList[indexPath.row]
        cell.textLabel?.text = pokemon.name
        if let imageData = pokemon.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectPokemon(at: indexPath.row)
    }
}

extension PokemonListViewController: PokemonListViewModelDelegate {
    func pokemonListViewModel(_ viewModel: PokemonListViewModel, didSelectPokemon pokemon: Pokemon) {
        let detailViewModel = PokemonDetailViewModel(pokemon: pokemon)
        let detailViewController = PokemonDetailViewController()
        detailViewController.viewModel = detailViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
