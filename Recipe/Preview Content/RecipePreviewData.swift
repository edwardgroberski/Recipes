//
//  RecipePreviewData.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import Foundation
import UIKit

let previewRecipes = [recipe1, recipe2, recipe3]

let recipe1 = Recipe(
    uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
    cuisine: "Malaysian",
    name: "Apam Balik",
    photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
    photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
    sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
    youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg")

let recipe2 = Recipe(
    uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f",
    cuisine: "British",
    name: "Apple & Blackberry Crumble",
    photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
    photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
    sourceUrl: "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
    youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4")

let recipe3 = Recipe(
    uuid: "f8b20884-1e54-4e72-a417-dabbc8d91f12",
    cuisine: "American",
    name: "Banana Pancakes",
    photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/small.jpg",
    photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b6efe075-6982-4579-b8cf-013d2d1a461b/large.jpg",
    sourceUrl: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
    youtubeUrl: "https://www.youtube.com/watch?v=kSKtb2Sv-_U")

let foodImage = UIImage(named: "food.jpg")!
