### Steps to Run the App
App will build and run by pressing play button in Xcode.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I prioritized focusing on code architecture with data flowing from API client, to services, and then to viewmodels. I wanted to make sure the code base could be scalable, testable, and maintainable. I also spent a lot of the time implementing my own recipe async image caching mechanism. This was an interesting problem to solve with the use of network requests, caching to disk, and concurrency.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent around a total of 6 hours on this project over the span of a few days. I spent extra time setting up dependency injection, UI previews, writing unit tests, and profiling in instruments.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
For simplicity, I tasked the RecipeListViewModel with storing the list of recipes. If recipes were going to be used in other places within the app, I would have created a RecipesRepository to manage the list of recipes.

### Weakest Part of the Project: What do you think is the weakest part of your project?
I would have liked to work on the UI more with supporting different ways to sort the recipes by cuisine, navigating users to external recipe links, etc.

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
The only external dependency is [Point-Free Dependencies](https://github.com/pointfreeco/swift-dependencies) library that I used for dependency injection. 


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Each view has previews to cover the different use cases. RecipesService can be edited to run valid, malformed, and empty API calls.
