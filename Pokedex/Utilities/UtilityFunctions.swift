//
//  UtilityFunctions.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import UIKit

class UtilityFunctions {
    
    static func getDataFromURL(url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
    
    
    static func convertStringToURL(urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw ResourceError.invalidURL(identifierString: urlString)
        }
        
        return url
    }
}
