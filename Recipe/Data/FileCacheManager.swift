//
//  FileCacheManager.swift
//  Recipe
//
//  Created by Edward Groberski on 11/29/24.
//

import Foundation
import Dependencies

struct FileCacheManager: Sendable {
    var createCacheDirectory: @Sendable (String) throws -> URL
    
    enum Error: LocalizedError {
        case unableToCreateDirectory
        
        var errorDescription: String? {
            switch self {
            case .unableToCreateDirectory:
                "Unable create cache directory"
            }
        }
    }
}


extension FileCacheManager: DependencyKey {
    static let liveValue = Self { path in
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0].appendingPathComponent(path)
        
        do {
            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            
            return cacheDirectory
        } catch {
            throw Error.unableToCreateDirectory
        }
    }
    
    static let testValue =  Self { path in
        URL(fileURLWithPath: path)
    }
    
    static let errorValue = Self { _ in
        throw Error.unableToCreateDirectory
    }
}

extension DependencyValues {
    var fileCacheManager: FileCacheManager {
        get { self[FileCacheManager.self] }
        set { self[FileCacheManager.self] = newValue }
    }
}
