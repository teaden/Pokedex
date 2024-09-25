//
//  PokemonDecoder.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

/// Encapsulates JSON decoding logic for Pokemon records
class PokemonDecoder {
    static func decode(from jsonDataURL: URL) throws -> MultiplePokemonModel {
        
        let jsonData = try Data(contentsOf: jsonDataURL)
        
        let decoder = JSONDecoder()
        
        /// Ensures JSON attribute names with underscores can be converted to lowerCamelCase Swift property names
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedPokemon: MultiplePokemonModel = try decoder.decode(MultiplePokemonModel.self, from: jsonData)
        
        return decodedPokemon
    }
}
