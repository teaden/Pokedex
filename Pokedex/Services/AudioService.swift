//
//  AudioService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import AVFAudio

/// Encapsulates functionality for fetching audio files locally or from network requests
/// Also incorporates functionality for loading audio files into AVAudioPlayer objects and preparing the players
class AudioService: RemoteServiceProtocol, LocalServiceProtocol {
    typealias ResultType = AVAudioPlayer
    
    /// Gathers array of AVAudioPlayers based on an array of String links
    /// Used to get sound or battle cry audio files for an array of cry links mapped from MultplePokemonModel.pokemon array of SinglePokemonModel records
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [AVAudioPlayer] {
        /// Prefill array that will house the sound players
        /// The goal of prefilling is to allow separate threads to fetch the audio for separate array indices
        var audioPlayers: [AVAudioPlayer?] = Array(repeating: nil, count: urlStrings.count)

        /// Utilize structured concurrency to fill audioPlayers array with AVAudioPlayer objects based on String links
        /// The use of withThrowingTaskGroup means that the entire operation fails if one fetch fails
        return try await withThrowingTaskGroup(of: (Int, AVAudioPlayer).self) { group in
            for (index, urlString) in urlStrings.enumerated() {
                group.addTask {
                    /// Convert String audio file link to URL and perform the network request
                    let (data, _) = try await UtilityFunctions.getDataFromURL(url: UtilityFunctions.convertStringToURL(urlString: urlString))
                    
                    /// Converting data from network request to AVAudioPlayer done on Main thread in case conversion is not thread safe
                    let audioPlayer = try await MainActor.run { try convertDataToAudioPlayer(audioData: data) }
                    return (index, audioPlayer)
                }
            }

            while let result = try await group.next() {
                let (index, audioPlayer) = result
                audioPlayers[index] = audioPlayer
            }

            /// Make each AVAudioPlayer non-optional by ensuring remaining nils are removed
            return audioPlayers.compactMap { $0 }
        }
    }
    
    /// Gathers single AVAudioPlayer for a given audio file's String link
    static func fetch(fromStringURL urlString: String) async throws -> AVAudioPlayer {
        let audioURL = try UtilityFunctions.convertStringToURL(urlString: urlString)
        let (audioData, _) = try await UtilityFunctions.getDataFromURL(url: audioURL)
        return try AudioService.convertDataToAudioPlayer(audioData: audioData)
    }
    
    /// Gathers single AVAudioPlayer for a file that exists in the project directory
    static func fetch(fromResourceName fileName: String, withExtension extensionName: String) throws -> AVAudioPlayer {
        
        guard let audioDataURL = Bundle.main.url(forResource: fileName, withExtension: extensionName) else {
            throw ResourceError.invalidURL(identifierString: fileName)
        }
        
        let audioPlayer = try AVAudioPlayer(contentsOf: audioDataURL)
        audioPlayer.prepareToPlay()
        
        return audioPlayer
    }
    
    /// Static helper function that tries to instantiate AVAudioPlayer with network response data
    private static func convertDataToAudioPlayer(audioData: Data) throws -> AVAudioPlayer {
        let audioPlayer = try AVAudioPlayer(data: audioData)
        audioPlayer.prepareToPlay()
        return audioPlayer
    }
}
