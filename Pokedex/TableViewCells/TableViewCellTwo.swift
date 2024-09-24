//
//  TableViewCellTwo.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

class TableViewCellTwo: UITableViewCell {
    
    var pokemon: SinglePokemonModel?
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailsSwitch: UISwitch!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        updateDetailsLabel()
    }

    func configure(with pokemon: SinglePokemonModel) {
        self.pokemon = pokemon
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        mainLabel.text = "\(pokemon.id)"
        
        updateDetailsLabel()
    }

    private func updateDetailsLabel() {
        guard let pokemon = pokemon else { return }
        if detailsSwitch.isOn {
            detailsLabel.text = "Held Item: \(pokemon.heldItem ?? "None")"
        } else {
            detailsLabel.text = "Type: \(pokemon.types[0])"
        }
    }

}
