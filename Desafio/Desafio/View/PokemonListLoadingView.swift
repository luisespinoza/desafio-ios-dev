//
//  PokemonListLoadingView.swift
//  Desafio
//
//  Created by Luis Enrique Espinoza Severino on 05-12-24.
//

import UIKit

final class PokemonListLoadingView: UIView {
    private let activityIndicator: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
}
