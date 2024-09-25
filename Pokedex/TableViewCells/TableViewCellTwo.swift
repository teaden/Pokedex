//
//  TableViewCellTwo.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

/// Subclass code for dynamic prototype TableView cell with reuse ID "TypeTwoId"
/// For Pokemon with 1 type (e.g., fire) and a held item (e.g., Lum Berry)
class TableViewCellTwo: UITableViewCell {
    
    /// Store single pokemon record that links to current cell for dynamic info reference
    var pokemon: SinglePokemonModel?
    
    /// Outlet to UIImage that will house Pokemon GIF
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    /// Outlet to main text label that will include Pokemon's Pokedex ID and name
    @IBOutlet weak var mainLabel: UILabel!
    
    /// Outlet to Switch that changes text in "details" label
    @IBOutlet weak var detailsSwitch: UISwitch!
    
    /// Outlet to "details" text label that will include Pokemon type info (i.e., fire)
    @IBOutlet weak var detailsLabel: UILabel!
    
    /// Action that triggers Switch value changes to update UI
    @IBAction func switchToggle(_ sender: UISwitch) {
        updateDetailsLabel()
    }

    func configure(with pokemon: SinglePokemonModel) {
        self.pokemon = pokemon
        
        /// Give pokemonImageView GIF using Kingfisher cache
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        
        mainLabel.text = "\(pokemon.id)"
        updateDetailsLabel()
    }
    
    /// Used to update "details" label text to type or held item info based on Switch value
    private func updateDetailsLabel() {
        guard let pokemon = pokemon else { return }
        if detailsSwitch.isOn {
            detailsLabel.text = "Held Item: \(pokemon.heldItem ?? "None")"
        } else {
            detailsLabel.text = "Type: \(pokemon.types[0])"
        }
    }
}
