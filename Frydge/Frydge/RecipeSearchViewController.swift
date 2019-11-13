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
 
    static let ingredients = [Ingredient(name: "some kind of dough", amount: 1), Ingredient(name: "roasted red grapes", amount: 1), Ingredient(name: "double cream Brie", amount: 1), Ingredient(name: "caramelized onions", amount: 1), Ingredient(name: "Parmesan", amount: 1), Ingredient(name: "fresh wild arugula", amount: 1)]
    static let process = """
        1. Prepare dough.
        2. Assemble ingredients.
        3. Cook.
        4. Plate.
        """
    
    static let ingredients2: [Ingredient] = []
    static let process2 = ""

    let recipes = [
        Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process),
        Recipe(id: 1, title: "Grilled Chicken Sonoma Flatbread 2", ingredientList: ingredients2, process: process2)
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        var recipeViews: [UIView] = []

        for recipe in recipes {
            recipe.setImage(byName: "sonoma")
            guard let recipeView = recipe.recipePreview() else { return }
            view.backgroundColor = .white
            recipeViews.append(recipeView)
        }

        view.addSubview(backgroundImage)
        
        var list = [backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
                backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
                backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        var i = 0
        for recipeView in recipeViews {
            view.addSubview(recipeView)
            
            let top = (200 * i) + 50
        
            list.append(recipeView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            i = i + 1
        }

        NSLayoutConstraint.activate(list)
    }

}
