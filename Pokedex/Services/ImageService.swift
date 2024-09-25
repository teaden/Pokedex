//
//  ImageService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import UIKit

/// Encapsulates functionality for fetching UIImages from Xcode assets or from network requests
class ImageService: RemoteServiceProtocol {
    typealias ResultType = UIImage
    
    /// Gathers array of UIImages based on an array of String links
    /// Used to get images for an array of artwork links for one SinglePokemonModel in a MultplePokemonModel.pokemon array
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [UIImage] {
        /// Prefill array that will house the UIImages
        /// The goal of prefilling is to allow separate threads to fetch the audio for separate array indices
        var images: [UIImage?] = Array(repeating: nil, count: urlStrings.count)

        /// Utilize structured concurrency to fill images array with UIImage objects based on String links
        /// The use of withThrowingTaskGroup means that the entire operation fails if one fetch fails
        return try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
            for (index, urlString) in urlStrings.enumerated() {
                group.addTask {
                    /// Convert String audio file link to URL and perform the network request
                    let (data, _) = try await UtilityFunctions.getDataFromURL(url: UtilityFunctions.convertStringToURL(urlString: urlString))
                    
                    /// Conversion from network response data to UIImage is performed on the Main thread
                    /// Although UIImage is Sendable, the conversion process may not be thread safe
                    let image = try await MainActor.run { try convertDataToImage(imageData: data) }
                    return (index, image)
                }
            }

            while let result = try await group.next() {
                let (index, image) = result
                images[index] = image
            }
            /// Make each UIImage non-optional by ensuring remaining nils are removed
            return images.compactMap { $0 }
        }
    }
    
    /// Gathers single UIImage for a given image file's String link
    static func fetch(fromStringURL urlString: String) async throws -> UIImage {
        let imageURL = try UtilityFunctions.convertStringToURL(urlString: urlString)
        let (imageData, _) = try await UtilityFunctions.getDataFromURL(url: imageURL)
        return try ImageService.convertDataToImage(imageData: imageData)
    }
    
    /// Gathers single UIImage for a file that exists in Xcode project assets
    static func fetchFromAssets(fromResourceName fileName: String) throws -> UIImage {
        guard let image = UIImage(named: fileName) else {
            throw ResourceError.noImageInAssets
        }
        
        return image
    }
    
    /// Static helper function that tries to instantiate UIImage with network response data
    private static func convertDataToImage(imageData: Data) throws -> UIImage {
        guard let image = UIImage(data: imageData) else {
            throw ResourceError.invalidImageData
        }
        return image
    }
}
