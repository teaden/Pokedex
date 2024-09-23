//
//  AssetModel.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import Foundation
import UIKit
import AVFAudio

class AssetModel {
    static func serveImage(fileName: String) throws -> UIImage {
        return try ImageService.fetchFromAssets(fromResourceName: fileName)
    }
    
    static func serveAudioPlayer(fileName: String, extensionType: String) throws -> AVAudioPlayer {
        return try AudioService.fetch(fromResourceName: fileName, withExtension: extensionType)
    }
}
