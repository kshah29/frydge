//
//  RecipeSearchViewController.swift
//  Frydge
//
//  Created by Natasha Sarkar on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class RecipeSearchViewController: UIViewController {
 
    public func getRecipes() -> [Recipe] {
        let ingredients = [Ingredient(name: "some kind of dough", amount: 1), Ingredient(name: "roasted red grapes", amount: 1), Ingredient(name: "double cream Brie", amount: 1), Ingredient(name: "caramelized onions", amount: 1), Ingredient(name: "Parmesan", amount: 1), Ingredient(name: "fresh wild arugula", amount: 1)]
        let process = """
            1. Prepare dough.
            2. Assemble ingredients.
            3. Cook.
            4. Plate.
            """
        
        let ingredients2: [Ingredient] = []
        let process2 = ""

        let recipes = [
            Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process,
                   image: "https://assets.kraftfoods.com/recipe_images/opendeploy/193146_640x428.jpg"),
            Recipe(id: 1, title: "Untitled Thing 2", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg")
        ]

        return recipes
    }
    
    let searchbar = UISearchBar(frame: CGRect(x: 10, y: 50, width: 400.0, height: 50.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.barTintColor = UIColor(named: "blue")
        view.addSubview(searchbar)
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        let recipes = getRecipes()
        var recipeViews: [UIView] = []

        for recipe in recipes {
            guard let recipeView = recipe.recipePreview() else { return }
            recipeViews.append(recipeView)
        }

        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        
        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        var i = 0
        for recipeView in recipeViews {
            view.addSubview(recipeView)
            
            let top = (220 * i) + 120
        
            list.append(recipeView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            i = i + 1
        }

        NSLayoutConstraint.activate(list)
    }
}
