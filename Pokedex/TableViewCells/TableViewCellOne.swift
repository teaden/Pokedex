//
//  TableViewCellOne.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

class TableViewCellOne: UITableViewCell {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configure(with pokemon: SinglePokemonModel) {
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        mainLabel.text = "\(pokemon.id)"
        detailsLabel.text = "Type: \(pokemon.types[0])"
    }
}
