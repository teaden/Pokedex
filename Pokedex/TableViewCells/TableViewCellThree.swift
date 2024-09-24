//
//  TableViewCellThree.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

class TableViewCellThree: UITableViewCell {
    
    var pokemon: SinglePokemonModel?

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var typeStepper: UIStepper!
    @IBOutlet weak var detailsLabel: UILabel!

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
        let numberOfTypes = Int(typeStepper.value)
        detailsLabel.text = "Types: \(pokemon.types.prefix(numberOfTypes).joined(separator: ", "))"
    }
}
