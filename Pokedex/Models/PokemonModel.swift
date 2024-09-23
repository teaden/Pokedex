//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import UIKit
import AVFAudio
import Kingfisher

class PokemonModel {
    
    var pokemonRecords: MultiplePokemonModel?
    var perPokemonImageArrays: [[UIImage]]?
    var perPokemonSounds: [AVAudioPlayer]?
    
    static let shared = PokemonModel()
    
    private init() {} 
    
    class func setup(with pokemonDataUrlString: String) async throws -> Void {
        print("Starting setup...")
        shared.pokemonRecords = try PokemonService.fetch(fromResourceName: pokemonDataUrlString, withExtension: ".json")
        print("Pokemon records gathered!")
        shared.perPokemonImageArrays = try await getPerPokemonImages(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon artwork arrays created!")
        shared.perPokemonSounds = try await getPerPokemonSounds(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon sound files gathered!")
        try await preloadPokemonGifs(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon sprite GIFs pre-fetched!")
    }
            
    private static func getPerPokemonImages(multiplePokemon: MultiplePokemonModel) async throws -> [[UIImage]] {
        
        let perPokemonImageUrls: [[String]] = multiplePokemon.pokemon.map { $0.artwork }
        
        var imageArrays: [[UIImage]?] = Array(repeating: nil, count: perPokemonImageUrls.count)

        try await withThrowingTaskGroup(of: (Int, [UIImage]).self) { group in
            for (index, urlStringArray) in perPokemonImageUrls.enumerated() {
                group.addTask {
                    let imageArray = try await ImageService.fetchAll(fromStringURLs: urlStringArray)
                    return (index, imageArray)
                }
            }

            while let result = try await group.next() {
                let (index, imageArray) = result
                imageArrays[index] = imageArray
            }
        }

        return imageArrays.compactMap { $0 }
    }
    
    private static func getPerPokemonSounds(multiplePokemon: MultiplePokemonModel) async throws -> [AVAudioPlayer] {
        let perPokemonAudioUrls: [String] = multiplePokemon.pokemon.map { $0.cry }
        return try await AudioService.fetchAll(fromStringURLs: perPokemonAudioUrls)
    }
    
    private static func preloadPokemonGifs(multiplePokemon: MultiplePokemonModel) async throws {
        let perPokemonGifUrls: [URL] = try multiplePokemon.pokemon.map {
            try UtilityFunctions.convertStringToURL(urlString: $0.sprite)
        }
        
        // Wraps KingFisher's traditionally completion-based API in modern Swift async/await pattern
        return await withCheckedContinuation { continuation in
            let prefetcher = ImagePrefetcher(urls: perPokemonGifUrls, options: nil, progressBlock: nil) { skippedResources, failedResources, completedResources in
                continuation.resume(returning: ())
            }

            prefetcher.start()
        }
    }
}




