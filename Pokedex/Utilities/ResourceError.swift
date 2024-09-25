//
//  ResourceError.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation

/// Custom error cases used to indicate various "fail" scenarios throughout the app
enum ResourceError: Error {
    case invalidURL(identifierString: String)
    case invalidImageData
    case noImageInAssets
    case imageViewUnavailable
    case loadingPokemonBeforeSetup
    case loadingImageBeforeSetup
    case loadingAudioBeforeSetup
}
