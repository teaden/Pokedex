//
//  PokemonService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

class PokemonService: LocalServiceProtocol {
    typealias ResultType = MultiplePokemonModel
    static func fetch(fromStringURL urlString: String) throws -> MultiplePokemonModel {
        
        guard let jsonDataURL = Bundle.main.url(forResource: urlString, withExtension: ".json") else {
            throw ResourceError.invalidURL(identifierString: urlString)
        }
        
        return try PokemonDecoder.decode(from: jsonDataURL)
    }
}
