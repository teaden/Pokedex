//
//  AudioService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import AVFAudio

class AudioService: RemoteServiceProtocol {
    typealias ResultType = AVAudioPlayer
    
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [AVAudioPlayer] {
        var audioPlayers: [AVAudioPlayer?] = Array(repeating: nil, count: urlStrings.count)

        return try await withThrowingTaskGroup(of: (Int, AVAudioPlayer).self) { group in
            for (index, urlString) in urlStrings.enumerated() {
                group.addTask {
                    let (data, _) = try await UtilityFunctions.getDataFromURL(url: UtilityFunctions.convertStringToURL(urlString: urlString))
                    let audioPlayer = try await MainActor.run { try convertDataToAudioPlayer(audioData: data) }
                    return (index, audioPlayer)
                }
            }

            while let result = try await group.next() {
                let (index, audioPlayer) = result
                audioPlayers[index] = audioPlayer
            }

            return audioPlayers.compactMap { $0 }
        }
    }
    
    static func fetch(fromStringURL urlString: String) async throws -> AVAudioPlayer {
        let audioURL = try UtilityFunctions.convertStringToURL(urlString: urlString)
        let (audioData, _) = try await UtilityFunctions.getDataFromURL(url: audioURL)
        return try AudioService.convertDataToAudioPlayer(audioData: audioData)
    }
    
    private static func convertDataToAudioPlayer(audioData: Data) throws -> AVAudioPlayer {
        let audioPlayer = try AVAudioPlayer(data: audioData)
        audioPlayer.prepareToPlay()
        return audioPlayer
    }
}
