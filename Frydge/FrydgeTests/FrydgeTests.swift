//
//  FrydgeTests.swift
//  FrydgeTests
//
//  Created by Megan Hong on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import XCTest
@testable import Frydge

class FrydgeTests: XCTestCase {
    
    private var recipe1 : Recipe!
    private var recipe2 : Recipe!
    private var recipe3 : Recipe!
    private var recipeStore : RecipeStore!
    private var ingredient1 : Ingredient!
    private var ingredient2 : Ingredient!
    private var recipeSearchViewController = RecipeSearchViewController()
    private var cookbookViewController = CookbookViewController()
    private var pantryViewController = PantryViewController()

    override func setUp() {
        recipe1 = Recipe(id: 100, title: "Recipe Title 1", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process1", image: "imageUrl1");
        recipe2 = Recipe(id: 200, title: "Recipe Title 2", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process2", image: "imageUrl2");
        recipe3 = Recipe(id: 300, title: "Recipe Title 3", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process3", image: "imageUrl3");
        ingredient1 = Ingredient(name: "i1", amount: 1)
        ingredient2 = Ingredient(name: "i2", amount: 1)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddIngredientToShoppingList(){
        pantryViewController.addNewIngredient(ingredientName: ingredient1.name)
        XCTAssertEqual(pantryViewController.shoppingList.getIngredient(index: 0).name, ingredient1.name)
    }
    
    func testMoveIngredientsToPantryList(){
        pantryViewController.addNewIngredient(ingredientName: ingredient1.name)
        pantryViewController.addNewIngredient(ingredientName: ingredient2.name)
        pantryViewController.moveIngredients()
        XCTAssertEqual(pantryViewController.pantryList.getIngredient(index: 0).name, ingredient1.name)
        XCTAssertEqual(pantryViewController.pantryList.getIngredient(index: 1).name, ingredient2.name)
    }
    
    func testDeleteIngredientFromShoppingList(){
        pantryViewController.addNewIngredient(ingredientName: ingredient1.name)
        pantryViewController.addNewIngredient(ingredientName: ingredient2.name)
        pantryViewController.removeIngredient(index: 0)
        XCTAssertEqual(pantryViewController.shoppingList.getIngredient(index: 0).name, ingredient2.name)
    }
    
    func testAddRecipesToRecipeStore() {
        RecipeStore.add(addRecipe: recipe1)
        RecipeStore.add(addRecipe: recipe2)
        RecipeStore.add(addRecipe: recipe3)
        
        XCTAssertEqual(RecipeStore.getRecipeList()[0].id, recipe1.id)
        XCTAssertEqual(RecipeStore.getRecipeList()[1].id, recipe2.id)
        XCTAssertEqual(RecipeStore.getRecipeList()[2].id, recipe3.id)
    }
    
    func testDeleteRecipesInRecipeStore() {
        RecipeStore.delete(delRecipe: recipe1)
        RecipeStore.delete(delRecipe: recipe2)
        RecipeStore.delete(delRecipe: recipe3)
        
        XCTAssertTrue(RecipeStore.getRecipeList().count == 0)
    }

    func testDummyMakeRequest() {
        recipeSearchViewController.dummyMakeRequest()
        let populatedRecipes = recipeSearchViewController.recipes
        
        XCTAssertEqual(populatedRecipes![0].title, "Grilled Chicken Sonoma Flatbread")
        XCTAssertEqual(populatedRecipes![8].title, "Another Thing")
    }
    
    func testAddToCookbook() {
        RecipeStore.add(addRecipe: recipe1)
        let favoritedRecipes = cookbookViewController.getFavoriteRecipe()
        
        XCTAssertEqual(favoritedRecipes[0].title, "Recipe Title 1")
    }
    
    func testMakeRequest (){
        
    }
    
}
