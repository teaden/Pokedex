//
//  TableViewCellFour.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit
import Kingfisher

/// Subclass code for dynamic prototype TableView cell with reuse ID "TypeFourId"
/// For Pokemon with 2+ types (e.g., fire, ground) and a held item (e.g., Lum Berry)
class TableViewCellFour: UITableViewCell {
    
    /// Store single pokemon record that links to current cell for dynamic info reference
    var pokemon: SinglePokemonModel?

    /// Outlet to UIImage that will house Pokemon GIF
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    /// Outlet to main text label that will include Pokemon's Pokedex ID and name
    @IBOutlet weak var mainLabel: UILabel!
    
    /// Outlet to Switch that changes text in "details" label
    @IBOutlet weak var detailsSwitch: UISwitch!
    
    /// Outlet to Stepper that increments number of types shown in "details" label
    @IBOutlet weak var typeStepper: UIStepper!
    
    /// Outlet to "details" text label that will include Pokemon type info (i.e., fire)
    @IBOutlet weak var detailsLabel: UILabel!
    
    /// Action that triggers Switch value changes to update UI
    @IBAction func switchToggle(_ sender: UISwitch) {
        updateDetailsLabel()
    }
    
    /// Action that triggers Stepper value changes to update UI
    @IBAction func stepperValueChange(_ sender: UIStepper) {
        updateDetailsLabel()
    }
    
    func configure(with pokemon: SinglePokemonModel) {
        self.pokemon = pokemon
        
        /// Give pokemonImageView GIF using Kingfisher cache
        pokemonImageView.kf.setImage(with: URL(string: pokemon.sprite)!)
        mainLabel.text = "\(pokemon.id)"

        /// Ensure Stepper values align with number of elements in Pokemon record's type array
        typeStepper.minimumValue = 1
        typeStepper.maximumValue = Double(pokemon.types.count)
        typeStepper.value = 1
        
        updateDetailsLabel()
    }
    
    /// Used to update "details" label text to type or held item info based on Switch value
    /// Stepper is hidden if Switch value is "on" and indicates held item text
    /// Used to update "details" label text by concatenating number of type Strings specified by Stepper
    private func updateDetailsLabel() {
        guard let pokemon = pokemon else { return }
        
        if detailsSwitch.isOn {
            detailsLabel.text = "Held Item: \(pokemon.heldItem ?? "None")"
            typeStepper.isHidden = true
        } else {
            let numberOfTypes = Int(typeStepper.value)
            detailsLabel.text = "Types: \(pokemon.types.prefix(numberOfTypes).joined(separator: ", "))"
            typeStepper.isHidden = false
        }
    }
}
