//
//  PokemonGenerations.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

// Each case is a different generation of Pokemon that the user can ultimately select via a Picker
// Computed property 'source' is the name of the JSON file that has specified generation of Pokemon records
enum PokemonGens: String {
    case genOne = "GenerationOne"
    case genTwo = "GenerationTwo"
    case genThree = "GenerationThree"
}
