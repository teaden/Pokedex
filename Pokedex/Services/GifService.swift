//
//  GifService.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import Foundation
import Kingfisher

class GifService {
    
    // Wraps KingFisher's traditionally completion-based API in modern Swift async/await pattern
    static func cacheGifs(forUrls gifUrls: [URL]) async {
        
        GifService.setupCacheLimits(withLimit: gifUrls.count)
        
        return await withCheckedContinuation { continuation in
            let prefetcher = ImagePrefetcher(urls: gifUrls, options: nil, progressBlock: nil) { skippedResources, failedResources, completedResources in
                continuation.resume(returning: ())
            }

            prefetcher.start()
        }
    }
    
    // Setup Kingfisher cache limits
    private static func setupCacheLimits(withLimit numRecords: Int) {
        let cache = ImageCache.default
        cache.memoryStorage.config.countLimit = numRecords
    }
    

    
    
    
    
}
