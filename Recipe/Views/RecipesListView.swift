//
//  RecipesListView.swift
//  Recipe
//
//  Created by Edward Groberski on 11/25/24.
//

import SwiftUI
import Dependencies

struct RecipesListView: View {
    private let viewModel: RecipesListViewModel
    
    init(viewModel: RecipesListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .loaded(let recipes):
                    recipesView(recipes)
                case .empty:
                    emptyRecipesView
                case .failure:
                    failureView
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await viewModel.refreshRecipes()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationTitle("Recipes")
        }.task {
            await viewModel.refreshRecipes()
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5)
            .padding()
    }
    
    @ViewBuilder
    func recipesView(_ recipes: [RecipeItemViewModel]) -> some View {
        LazyVStack {
            ForEach(recipes, id: \.id) {
                RecipeItemView(viewModel: $0)
            }
        }.padding(.horizontal)
    }
    
    private var emptyRecipesView: some View {
        Text("No Recipes Available")
    }
    
    private var failureView: some View {
        Text("Unable to retrieve recipes")
    }
}

#Preview("All Recipes") {
    withDependencies {
        $0.recipesService = .testValue
    } operation: {
        RecipesListView(viewModel: RecipesListViewModel())
    }
}

#Preview("Empty Recipes") {
    {
        prepareDependencies {
            $0.recipesService = .emptyValue
        }
        return withDependencies {
            $0.recipesService = .emptyValue
        } operation: {
            RecipesListView(viewModel: RecipesListViewModel())
        }
        
    }()
}

#Preview("Failure Recipes") {
    {
        prepareDependencies {
            $0.recipesService = .errorValue
        }
        return withDependencies {
            $0.recipesService = .errorValue
        } operation: {
            RecipesListView(viewModel: RecipesListViewModel())
        }
        
    }()
}
