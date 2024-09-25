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

/// Singleton class model that houses Pokemon records from JSON and any accompanying image or audio elements
class PokemonModel {
    
    /// Array of Pokemon records that maps to outermost "pokemon" attribute in JSON files
    var pokemonRecords: MultiplePokemonModel?
    
    /// Used for storing array of potentially multiple artwork images per single Pokemon
    /// Images are fetched from links in the SinglePokemonModel records in MultiplePokemonModel
    /// Indicies of below array follow those of MultiplePokemonModel.pokemon array
    var perPokemonImageArrays: [[UIImage]]?
    
    /// Used for storing sounds or battle cries per single Pokemon
    /// Audio files fetched and converted to AVAudioPlayers from links in the SinglePokemonModel records in MultiplePokemonModel
    /// Indicies of below array follow those of MultiplePokemonModel.pokemon array
    var perPokemonSounds: [AVAudioPlayer]?
    
    /// Mark PokemonModel as a shared Singleton class
    static let shared = PokemonModel()
    
    /// Private init is simply included to follow convention and denote class as singleton class
    private init() {}
    
    /// Loads pokemon records from JSON, fetches any accompanying images, audio, and GIFs
    class func setup(with pokemonDataUrlString: String) async throws -> Void {
        print("Starting setup...")
        
        /// Loads pokemon records (i.e., a MultiplePokemonModel instance) from JSON file
        shared.pokemonRecords = try PokemonService.fetch(fromResourceName: pokemonDataUrlString, withExtension: ".json")
        print("Pokemon records gathered!")
        
        /// Fetches artwork image arrays for MultiplePokemonModel pokemon loaded from JSON based on "artwork" String links in SinglePokemonModel
        shared.perPokemonImageArrays = try await getPerPokemonImages(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon artwork arrays created!")
        
        /// Fetches audio for MultiplePokemonModel pokemon loaded from JSON based on "cry" String links in SinglePokemonModel
        shared.perPokemonSounds = try await getPerPokemonSounds(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon sound files gathered!")
        
        /// Caches GIFs for MultiplePokemonModel pokemon loaded from JSON based on "sprite" String links in SinglePokemonModel
        try await preloadPokemonGifs(multiplePokemon: shared.pokemonRecords!)
        print("Pokemon sprite GIFs pre-fetched!")
    }
    
    /// Class function that retrieves a single pokemon based on index in MultiplePokemon.pokemon array
    class func getPokemonByIndex(index idx: Int) throws -> SinglePokemonModel {
        guard let pokemonMultiple = shared.pokemonRecords?.pokemon else {
            throw ResourceError.loadingPokemonBeforeSetup
        }
        
        return pokemonMultiple[idx]
    }
    
    /// Class function that retrieves all artwork UIImages for a pokemon based on index in MultiplePokemon.pokemon array
    class func getAllArtworkByIndex(index idx: Int) throws -> [UIImage] {
        guard let pokemonImages = shared.perPokemonImageArrays else {
            throw ResourceError.loadingImageBeforeSetup
        }
        
        return pokemonImages[idx]
    }
    
    /// Class function that retrieves first artwork UIImage for a pokemon based on index in MultiplePokemon.pokemon array
    class func getArtworkByIndex(index idx: Int) throws -> UIImage {
        guard let pokemonImages = shared.perPokemonImageArrays else {
            throw ResourceError.loadingImageBeforeSetup
        }
        
        return pokemonImages[idx][0]
    }
    
    /// Class function that retrieves cry sound audio player for a pokemon based on index in MultiplePokemon.pokemon array
    class func getAudioByIndex(index idx: Int) throws -> AVAudioPlayer {
        guard let pokemonSounds = shared.perPokemonSounds else {
            throw ResourceError.loadingAudioBeforeSetup
        }
        
        return pokemonSounds[idx]
    }
    
    /// Static helper that fetches artwork image arrays for MultiplePokemonModel pokemon loaded from JSON based on "artwork" String links in SinglePokemonModel
    private static func getPerPokemonImages(multiplePokemon: MultiplePokemonModel) async throws -> [[UIImage]] {
        /// Creates array of artwork String links arrays with indicies that map to MultiplePokemonModel.pokemon
        /// Basically extracts each pokemon's array of artwork String links into array separate from MultiplePokemonModel.pokemon -> [SinglePokemonModel] structure
        let perPokemonImageUrls: [[String]] = multiplePokemon.pokemon.map { $0.artwork }
        
        /// Prefill array of arrays that will house per-Pokemon artwork UIImages
        /// The goal of prefilling is to allow separate threads to fetch the images for separate array indices
        var imageArrays: [[UIImage]?] = Array(repeating: nil, count: perPokemonImageUrls.count)
        
        /// Utilize structured concurrency to fill imageArrays with per-Pokemon UIImages based on artwork String links
        /// The use of withThrowingTaskGroup means that the entire operation fails if one fetch fails
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
        
        /// Make each nested UIImage array non-optional by ensuring remaining nils are removed
        return imageArrays.compactMap { $0 }
    }
    
    /// Static helper that fetches cry sound audio players for MultiplePokemonModel pokemon loaded from JSON based on "cry" String links in SinglePokemonModel
    private static func getPerPokemonSounds(multiplePokemon: MultiplePokemonModel) async throws -> [AVAudioPlayer] {
        let perPokemonAudioUrls: [String] = multiplePokemon.pokemon.map { $0.cry }
        return try await AudioService.fetchAll(fromStringURLs: perPokemonAudioUrls)
    }
    
    /// Static helper that caches GIFs for MultiplePokemonModel pokemon loaded from JSON based on "sprite" String links in SinglePokemonModel
    private static func preloadPokemonGifs(multiplePokemon: MultiplePokemonModel) async throws {
        let perPokemonGifUrls: [URL] = try multiplePokemon.pokemon.map {
            /// Turns String link from "sprite" property into URL object
            try UtilityFunctions.convertStringToURL(urlString: $0.sprite)
        }
        
        await GifService.cacheGifs(forUrls: perPokemonGifUrls)
    }
}




