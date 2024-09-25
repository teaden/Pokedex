//
//  PokemonCellType.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import Foundation

/// Specifies which reusable cell to dequeue and manipulate in TableViewController
enum PokemonCellType {
    case oneTypeNoHeldItem
    case oneTypeHeldItem
    case multipleTypesNoHeldItem
    case multipleTypesHeldItem
}
