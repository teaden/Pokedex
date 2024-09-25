//
//  MultiPokemonModel.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/21/24.
//

import Foundation

/// Maps to array in "pokemon" attribute of JSON files
struct MultiplePokemonModel: Codable {
    var pokemon: [SinglePokemonModel]
}
