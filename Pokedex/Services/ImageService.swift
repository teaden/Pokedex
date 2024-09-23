//
//  ImageService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/22/24.
//

import Foundation
import UIKit

class ImageService: RemoteServiceProtocol {
    typealias ResultType = UIImage
    
    static func fetchAll(fromStringURLs urlStrings: [String]) async throws -> [UIImage] {
        var images: [UIImage?] = Array(repeating: nil, count: urlStrings.count)

        return try await withThrowingTaskGroup(of: (Int, UIImage).self) { group in
            for (index, urlString) in urlStrings.enumerated() {
                group.addTask {
                    let (data, _) = try await UtilityFunctions.getDataFromURL(url: UtilityFunctions.convertStringToURL(urlString: urlString))
                    let image = try await MainActor.run { try convertDataToImage(imageData: data) }
                    return (index, image)
                }
            }

            while let result = try await group.next() {
                let (index, image) = result
                images[index] = image
            }

            return images.compactMap { $0 }
        }
    }
    
    static func fetch(fromStringURL urlString: String) async throws -> UIImage {
        let imageURL = try UtilityFunctions.convertStringToURL(urlString: urlString)
        let (imageData, _) = try await UtilityFunctions.getDataFromURL(url: imageURL)
        return try ImageService.convertDataToImage(imageData: imageData)
    }
    
    static func fetchFromAssets(fromResourceName fileName: String) throws -> UIImage {
        guard let image = UIImage(named: fileName) else {
            throw ResourceError.noImageInAssets
        }
        
        return image
    }
    
    private static func convertDataToImage(imageData: Data) throws -> UIImage {
        guard let image = UIImage(data: imageData) else {
            throw ResourceError.invalidImageData
        }
        return image
    }
}
