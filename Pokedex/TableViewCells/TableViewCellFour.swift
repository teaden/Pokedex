//
//  TableViewCellFour.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit
import Kingfisher

class TableViewCellFour: UITableViewCell {
    
    var pokemon: SinglePokemonModel?

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var detailsSwitch: UISwitch!
    @IBOutlet weak var typeStepper: UIStepper!
    @IBOutlet weak var detailsLabel: UILabel!
    
    
    @IBAction func switchToggle(_ sender: UISwitch) {
        updateDetailsLabel()
    }
    
    @IBAction func stepperValueChange(_ sender: UIStepper) {
        updateDetailsLabel()
    }
    
    func configure(with pokemon: SinglePokemonModel) {
        self.pokemon = pokemon
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        mainLabel.text = "\(pokemon.id)"
        
        typeStepper.minimumValue = 1
        typeStepper.maximumValue = Double(pokemon.types.count)
        typeStepper.value = 1
        
        updateDetailsLabel()
    }
    
    private func updateDetailsLabel() {
        guard let pokemon = pokemon else { return }
        
        if detailsSwitch.isOn {
            detailsLabel.text = "Held Item: \(pokemon.heldItem ?? "None")"
            typeStepper.isHidden = true
        } else {
            // Show types, show the stepper
            let numberOfTypes = Int(typeStepper.value)
            detailsLabel.text = "Types: \(pokemon.types.prefix(numberOfTypes).joined(separator: ", "))"
            typeStepper.isHidden = false
        }
    }
}
