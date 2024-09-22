//
//  PokemonDecoder.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

class PokemonDecoder {
    static func decode(resourceName: String) throws -> MultiplePokemon {
        guard let jsonDataURL = Bundle.main.url(forResource: resourceName, withExtension: ".json") else {
            throw ResourceError.fileNotFound(fileName: resourceName)
        }
        
        let jsonData = try Data(contentsOf: jsonDataURL)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedPokemon: MultiplePokemon = try decoder.decode(MultiplePokemon.self, from: jsonData)
        
        return decodedPokemon
    }
}
