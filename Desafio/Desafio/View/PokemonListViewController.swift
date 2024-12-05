//
//  PokemonListViewController.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

import UIKit

class PokemonListViewController: UIViewController {
    var viewModel: PokemonListViewModel?
    
    private lazy var loadingView: PokemonListLoadingView = {
        let view = PokemonListLoadingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
        bindViewModel()
        viewModel?.onViewDidLoad()
    }
    
    private func bindViewModel() {
        viewModel?.isLoading = { [weak self] isLoading in
            self?.loadingView.isHidden = !isLoading
        }
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
