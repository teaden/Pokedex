//
//  PokemonService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

class PokemonService: LocalServiceProtocol {
    typealias ResultType = MultiplePokemonModel
    
    static func fetch(fromResourceName fileName: String, withExtension extensionName: String) throws -> MultiplePokemonModel {
        
        guard let jsonDataURL = Bundle.main.url(forResource: fileName, withExtension: extensionName) else {
            throw ResourceError.invalidURL(identifierString: fileName)
        }
        
        return try PokemonDecoder.decode(from: jsonDataURL)
    }
}
