//
//  RecipeStore.swift
//  Frydge
//
//  Created by Kanisha Shah on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation

class RecipeStore{
    static var recipeList: [Recipe] = [] // List of Recipes
    
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
}
