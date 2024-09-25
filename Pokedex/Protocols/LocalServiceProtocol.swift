//
//  LocalServiceProtocol.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

/// Custom protocol that classes fetching files from project directory must conform to
protocol LocalServiceProtocol: AnyObject {
    associatedtype ResultType
    
    static func fetch(
        fromResourceName fileName: String, withExtension extensionName: String) throws -> ResultType
}
