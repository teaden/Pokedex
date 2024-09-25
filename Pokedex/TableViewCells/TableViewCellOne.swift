//
//  TableViewCellOne.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

/// Subclass code for dynamic prototype TableView cell with reuse ID "TypeOneId"
/// For Pokemon with 1 type (e.g., fire) and no held item (e.g., Lum Berry)
class TableViewCellOne: UITableViewCell {
    /// Outlet to UIImage that will house Pokemon GIF
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    /// Outlet to main text label that will include Pokemon's Pokedex ID and name
    @IBOutlet weak var mainLabel: UILabel!
    
    /// Outlet to "details" text label that will include Pokemon type info (i.e., fire)
    @IBOutlet weak var detailsLabel: UILabel!
    
    func configure(with pokemon: SinglePokemonModel) {
        /// Give pokemonImageView GIF using Kingfisher cache
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        
        mainLabel.text = "\(pokemon.id)"
        detailsLabel.text = "Type: \(pokemon.types[0])"
    }
}
