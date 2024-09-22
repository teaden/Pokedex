//
//  SinglePokemon.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/21/24.
//

import Foundation

struct SinglePokemon: Codable {
    var id: Int
    var name: String
    var height: Int
    var baseExperience: Int
    var abilities: [String]
    var heldItems: [String]
    var stats: [String: Int]
    var artwork: [String]
    var sprite: String
    var cry: String
}
