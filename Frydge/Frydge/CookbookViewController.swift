 //
//  CookbookViewController.swift
//  Frydge
//
//  Created by Megan Hong on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class CookbookViewController: UIViewController {
 
    public func getRecipe() -> [Recipe] {
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
            Recipe(id: 0, title: "Pumpkin Spice Baked French Toast Sticks", ingredientList: ingredients, process: process,
                   image: "https://purelyelizabeth.com/wp-content/uploads/Pumpkin-Spice-Baked-French-Toast-Sticks.jpg"),
            Recipe(id: 1, title: "Peach and Mozerella Cauliflower Pizza", ingredientList: ingredients2, process: process2,
                   image: "https://purelyelizabeth.com/wp-content/uploads/0-3.jpg")
        ]

        return recipes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel()
            title.center.x = self.view.center.x
            title.frame.origin.y = 0
            title.textAlignment = .center
            title.text = "Cookbook"
            title.font = UIFont(name: "Comfortaa", size: 42)
            self.view.addSubview(title)
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.alpha = 0.5
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false
            
            let recipes = getRecipe()
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
