//
//  DataWriter.swift
//  Recipe
//
//  Created by Edward Groberski on 11/29/24.
//

import Foundation
import Dependencies
import SwiftUI

struct DataWriter: Sendable {
    var write: @Sendable (Data, URL) throws -> Void
    var read: @Sendable (URL) throws -> Data
    
    enum Error: LocalizedError {
        case writeFailed
        case readFailed
        
        var errorDescription: String? {
            switch self {
            case .writeFailed:
                "Writing data failed"
            case .readFailed:
                "Reading data failed"
            }
        }
    }
}

extension DataWriter: DependencyKey {
    static let liveValue = Self(
        write: { data, url in
            do {
                try data.write(to: url)
            } catch {
                throw Error.writeFailed
            }
        },read: { url in
            do {
                return try Data(contentsOf: url)
            } catch {
                throw Error.readFailed
            }
        }
    )
    
    static let testValue = Self(
        write: { _, _ in
        
        },read: { url in
            return UIImage(systemName: "fork.knife.circle.fill")!.pngData()!
        }
    )
    
    static let failureValue = Self(
        write: { _, _ in
            throw Error.writeFailed
        },read: { url in
            throw Error.readFailed
        }
    )
}

extension DependencyValues {
    var dataWriter: DataWriter {
        get { self[DataWriter.self] }
        set { self[DataWriter.self] = newValue }
    }
}
