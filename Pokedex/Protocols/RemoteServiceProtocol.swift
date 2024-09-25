//
//  RemoteServiceProtocol.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

/// Custom protocol that classes fetching files from network requests must conform to
protocol RemoteServiceProtocol: AnyObject {
    associatedtype ResultType
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [ResultType]
    static func fetch(fromStringURL urlString: String) async throws -> ResultType
}
