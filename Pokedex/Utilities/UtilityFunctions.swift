//
//  UtilityFunctions.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import UIKit

/// Group of utility functions used in multiple classes throughout the app
class UtilityFunctions {
    
    /// Performs a network request to gather data at point specified by URL
    static func getDataFromURL(url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
    
    /// Converts String link to URL object for use in advance of network requests
    static func convertStringToURL(urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw ResourceError.invalidURL(identifierString: urlString)
        }
        
        return url
    }
}
