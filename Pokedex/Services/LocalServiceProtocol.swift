//
//  LocalServiceProtocol.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

protocol LocalServiceProtocol {
    associatedtype ResultType
    static func fetch(fromStringURL urlString: String) throws -> ResultType
}
