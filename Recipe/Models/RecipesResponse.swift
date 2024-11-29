//
//  RecipesResponse.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import Foundation

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}
