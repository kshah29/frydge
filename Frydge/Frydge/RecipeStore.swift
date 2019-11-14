//
//  RecipeStore.swift
//  Frydge
//
//  Created by Kanisha Shah on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation

class RecipeStore{
    var recipeList: [Recipe] = [] // List of Recipes
    
    public func getRecipeList() -> [Recipe] {
        return recipeList
    }
    
    public func add(addRecipe : Recipe){
        recipeList.append(addRecipe)
    }
    
    public func delete(delRecipe : Recipe){
        for (index, element) in recipeList.enumerated(){
            if element.id == delRecipe.id{
                recipeList.remove(at: index)
            }
        }
        
    }
}
