//
//  PokemonService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

/// Encapsulates functionality for fetching Pokemon records from local JSON files in project directory
/// One JSON file has one array of Pokemon records which maps to one MultiplePokemonModel
/// One MultiplePokemonModel consists of multple SinglePokemonModel records
class PokemonService: LocalServiceProtocol {
    typealias ResultType = MultiplePokemonModel
    
    static func fetch(fromResourceName fileName: String, withExtension extensionName: String) throws -> MultiplePokemonModel {
        
        /// Converts file name to local bundle URL
        guard let jsonDataURL = Bundle.main.url(forResource: fileName, withExtension: extensionName) else {
            throw ResourceError.invalidURL(identifierString: fileName)
        }
        
        /// Sends bundle URL to encapsulated JSON decoder logic
        return try PokemonDecoder.decode(from: jsonDataURL)
    }
}
