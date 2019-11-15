#  Frydge

Frydge is an app that allows you to find new recipes that use ingredients you have, following personalized dietary restrictions. Save favorites to your Cookbook, track your Shopping List and Pantry of ingredients, and customize your Profile.

## Project Directory Structure

The Frydge folder contains everything needed for the Xcode project. Within it are the .xcodeproj file, Frydge, FrydgeTests, and README.md.

### Frydge
The Frydge directory contains two subdirectories: assets and src.

- assets: The assets directory contains all the fonts, images, colors, etc. used in the project.

- src: The src directory contains all the `.swift` files used in the project. We have not further divided this directory, as the classes here more or less work on the same level of abstraction and co-dependency. However, as we write class extensions and other tools and utilities, it may make sense to further segment the src folder.

### FrydgeTests
FrydgeTests contains the `FrydgeTests.swift` file, where all of our unit tests are defined.

#### Test Cases
1. We wanted to make sure our Recipe and RecipeStore class worked. In order to do this, we wrote a test case that added three hardcoded recipes to our RecipeStore. After adding these recipes, we checked with an assert statement that the recipes’ ids in `RecipeStore.recipeList` were equal to the ids of the three recipes that we hardcoded.

2. After adding these recipes to the RecipeStore, we deleted all three of the recipes and asserted that `RecipeStore.recipeList` was an empty list to make sure the delete function was working. We checked if the recipeList was empty by using the `assertTrue` method that compared the count of `RecipeStore.getRecipeList()` to `0`.
```
func testDeleteRecipesInRecipeStore() {
    RecipeStore.delete(delRecipe: recipe1)
    RecipeStore.delete(delRecipe: recipe2)
    RecipeStore.delete(delRecipe: recipe3)
    
    XCTAssertTrue(RecipeStore.getRecipeList().count == 0)
}
```

3. We also wanted to make sure that our `dummyMakeRequest()` function worked, because even though it populates our recipes with fake data, a similar format will be used when our recipes will have real data. To test this, we wrote a test case that made a call to `dummyMakeRequest` and then asserted that `RecipeSearchViewController.recipes` was the correct list of recipes that it was supposed to be. We tested the titles of two of the recipes populated, at position 0 and 8, to make sure they were equal to the titles of the correct hardcoded recipes.

4. Next, we made sure that the Cookbook class’s `getFavoritedRecipes()` method was receiving the correct recipes when we favorited recipes. To test this, we added a hardcoded recipe to the RecipeStore and then tested that it was getting added to the list of recipes that is returned in CookbookViewController’s `getFavoritedRecipes()` method. By comparing the titles of the recipe in the list with the hardcoded recipe, we were able to verify that the method was correctly populating the Cookbook.

5. Our last test case was done visually (no coded unit tests for this one), as we wanted to make sure that favoriting the recipes resulted in adding those recipes to the cookbook. To test this, we favorited a few recipes from the Search page and checked that those recipes showed up on the Cookbook page as well.


## Documentation
Doc comments similar to JavaDoc style can be added in Swift like so:
```
/**
Initializes a new recipe from the title, ingredients, process, and optionally image specified.

- Parameters:
    - id: A unique ID for the dish, taken from the Spoonacular API
    - title: The name of the dish
    - ingredientList: Ingredients needed for the dish
    - process: A string describing the instructions to create the dish
    - image: A string naming an image from assets (used primarily for testing with dummy data)
    

- Returns: A Recipe object, the foundation of many features in our app
*/
```
We tried using this style of documentation in `Recipe.swift`
