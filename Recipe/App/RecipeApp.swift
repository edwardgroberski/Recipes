//
//  RecipeApp.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import SwiftUI
import XCTestDynamicOverlay
import Dependencies

@main
struct RecipeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            // Prevent root view from running during tests
            if !_XCTIsTesting {
                RecipesListView(viewModel: RecipesListViewModel())
            }
        }
    }
}
