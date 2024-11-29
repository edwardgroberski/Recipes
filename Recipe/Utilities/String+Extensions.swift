//
//  String+Extensions.swift
//  Recipe
//
//  Created by Edward Groberski on 11/28/24.
//

import Foundation
import CryptoKit

extension String {
    // Function to convert a URL string to a reproducible UUID
    func uuidFromURLString() -> String? {
        // Step 1: Hash the URL string using SHA-256
        guard let data = data(using: .utf8) else {
            return nil
        }
        let hash = SHA256.hash(data: data)
        
        // Step 2: Extract the first 16 bytes (128 bits) for the UUID
        let uuidData = hash.prefix(16)
        
        // Step 3: Create a UUID from these 16 bytes
        var uuidBytes = [UInt8](uuidData)
        
        // Step 4: Adjust to conform to UUID version 4 format
        uuidBytes[6] = (uuidBytes[6] & 0x0F) | 0x40 // Set version to 4
        uuidBytes[8] = (uuidBytes[8] & 0x3F) | 0x80 // Set variant to RFC 4122
        
        // Step 5: Return the UUID
        return UUID(uuid: (
            uuidBytes[0], uuidBytes[1], uuidBytes[2], uuidBytes[3],
            uuidBytes[4], uuidBytes[5],
            uuidBytes[6], uuidBytes[7],
            uuidBytes[8], uuidBytes[9],
            uuidBytes[10], uuidBytes[11], uuidBytes[12], uuidBytes[13], uuidBytes[14], uuidBytes[15]
        )).uuidString
    }
}


