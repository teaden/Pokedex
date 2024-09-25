//
//  AssetModel.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import Foundation
import UIKit
import AVFAudio

/// Static helper functionality that is used for loading 'static' data from files
class AssetModel {
    /// Retrieves an image from Xcode assets
    static func serveImage(fileName: String) throws -> UIImage {
        return try ImageService.fetchFromAssets(fromResourceName: fileName)
    }
    
    /// Retrieves audio file stored in Xcode project directory (typically in the Data subfolder)
    static func serveAudioPlayer(fileName: String, extensionType: String) throws -> AVAudioPlayer {
        return try AudioService.fetch(fromResourceName: fileName, withExtension: extensionType)
    }
}
