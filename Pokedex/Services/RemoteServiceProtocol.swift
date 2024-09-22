//
//  RemoteServiceProtocol.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

protocol RemoteServiceProtocol {
    associatedtype ResultType
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [ResultType]
    static func fetch(fromStringURL urlString: String) async throws -> ResultType
}
