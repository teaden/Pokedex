//
//  GifService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import Foundation
import Kingfisher

/// Encapsulates functionality for fetching and caching GIFs via network requests using String links
class GifService {
    
    /// Wraps KingFisher's traditionally completion-based API in modern Swift async/await pattern
    static func cacheGifs(forUrls gifUrls: [URL]) async {
        
        GifService.setupCacheLimits(withLimit: gifUrls.count)
        
        return await withCheckedContinuation { continuation in
            let prefetcher = ImagePrefetcher(urls: gifUrls, options: nil, progressBlock: nil) { skippedResources, failedResources, completedResources in
                continuation.resume(returning: ())
            }

            prefetcher.start()
        }
    }
    
    /// Setup Kingfisher cache limits to ensure cache indices perfectly map to indices of data records in MVC Model state
    private static func setupCacheLimits(withLimit numRecords: Int) {
        let cache = ImageCache.default
        cache.memoryStorage.config.countLimit = numRecords
    }
}
