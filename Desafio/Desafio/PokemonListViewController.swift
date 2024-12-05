//
//  PokemonListViewController.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 03-12-24.
//

import UIKit

class PokemonListViewController: UIViewController {
    private var viewModel: PokemonListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel?.onViewDidLoad()
    }
}

