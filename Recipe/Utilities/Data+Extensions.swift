//
//  Data+Extensions.swift
//  Recipe
//
//  Created by Edward Groberski on 11/26/24.
//

import Foundation

enum RecipeJSONFile: String {
    case valid = "valid_recipes"
    case malformed = "malformed_recipes"
    case empty = "empty_recipes"
}

extension Data {
    init(jsonFile: String) {
        let url = Bundle.main.url(forResource: jsonFile, withExtension: "json")!
        try! self.init(contentsOf: url)
    }
}
