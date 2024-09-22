//
//  PokemonDecoder.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

class PokemonDecoder {
    static func decode(from jsonDataURL: URL) throws -> MultiplePokemonModel {
        
        let jsonData = try Data(contentsOf: jsonDataURL)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedPokemon: MultiplePokemonModel = try decoder.decode(MultiplePokemonModel.self, from: jsonData)
        
        return decodedPokemon
    }
}
