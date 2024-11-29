//
//  Recipe.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import Foundation

struct Recipe: Decodable, Equatable {
    let uuid: String
    let cuisine: String
    let name: String
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case cuisine
        case name
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
