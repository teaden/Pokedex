//
//  ResourceError.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

enum ResourceError: Error {
    case invalidURL(identifierString: String)
    case invalidImageData
}
