//
//  RecipeStore.swift
//  Frydge
//
//  Created by Kanisha Shah on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation

class RecipeStore{
    private static var username : String = ""
    static var recipeList: [Recipe] = [] { // List of Recipes
        didSet {
            writeRecipeData()
        }
    }
    static public func getRecipeList() -> [Recipe] {
        return recipeList
    }
    
    static public func add(addRecipe : Recipe){
        recipeList.append(addRecipe)
    }
    
    static public func delete(delRecipe : Recipe){
        for (index, element) in recipeList.enumerated(){
            if element.id == delRecipe.id{
                recipeList.remove(at: index)
            }
        }
    }
    
    
    static public func setRecipeStoreFromSuccessfulLogin(username: String) {
        var userRecipes: [[String:Any]]?
        let userList = readPlist(namePlist: "ExampleUsers", key: "Users") as! [[String:Any]]
        for user in userList {
            if username == (user["Username"] as? String ?? "") {
                userRecipes = user["Favorites"] as? [[String:Any]]
                break
            }
        }
        guard let recipes = userRecipes else { return }
        
        self.username = username
        for recipe in recipes {
            if let r_id = recipe["id"] as? Int, let r_title = recipe["title"] as? String, let r_process = recipe["process"] as? [String] {
                let r_image = (recipe["image"] as? String) ?? nil
                let r_preppingTime = (recipe["preppingTime"] as? Int) ?? nil
                let r_cookingTime = (recipe["cookingTime"] as? Int) ?? nil
                
                let newRecipe = Recipe(id: r_id, title: r_title, ingredientList: [], process: r_process, image: r_image, prepTime: r_preppingTime, cookTime: r_cookingTime)
                newRecipe.isFavorited = true
                recipeList.append(newRecipe)
            }
        }
    }
    private static func writeRecipeData() {
        let readUsers = readPlist(namePlist: "ExampleUsers", key: "Users") as! [[String:Any]]
        if var userList = readUsers as? [[String:Any]] {
            var userObject: [String: Any]?
            var userRecipes: [[String:Any]]?
            var index = 0
            for user in userList {
                if username == (user["Username"] as? String ?? "") {
                    userObject = user
                    userRecipes = user["Favorites"] as? [[String:Any]]
                    break
                }
                index += 1
            }
            if userRecipes == nil { return }
            
            var recipeListToWrite: [[String:Any]] = []
            for recipe in recipeList {
                var recipeDict: [String:Any] = [:]
                recipeDict["id"] = recipe.id
                recipeDict["title"] = recipe.title
                recipeDict["process"] = recipe.process
                recipeDict["image"] = recipe.imageUrl
                recipeDict["preppingTime"] = recipe.preppingTime
                recipeDict["cookingTime"] = recipe.cookingTime
                recipeListToWrite.append(recipeDict)
            }
            userRecipes = recipeListToWrite
            userObject!["Favorites"] = userRecipes
            userList[index] = userObject!
            writePlist(namePlist: "ExampleUsers", key: "Users", data: userList as AnyObject)
        }
    }
}
