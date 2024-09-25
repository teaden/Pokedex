//
//  SinglePokemonModel.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/21/24.
//

import Foundation

/// Maps to one object in array in "pokemon" attribute of JSON files
struct SinglePokemonModel: Codable {
    var id: Int
    var name: String
    var height: Int
    var weight: Int
    var baseExperience: Int
    var types: [String]
    var abilities: [String]
    var heldItem: String?
    var stats: [String: Int]
    var artwork: [String]
    var sprite: String
    var cry: String
    
    /// Computed property used for conditionally dequeuing dynamic cell prototypes in TableViewController
    var cellType: PokemonCellType {
        if types.count > 1 && heldItem != nil {
            return .multipleTypesHeldItem
        } else if types.count > 1 {
            return .multipleTypesNoHeldItem
        } else if heldItem != nil {
            return .oneTypeHeldItem
        } else {
            return .oneTypeNoHeldItem
        }
    }
}
