//
//  TestTabViewController.swift
//  Frydge
//
//  Created by Ian Costello on 11/7/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class TestTabViewController: UIViewController {
    static let ingredients = [Ingredient(name: "some kind of dough", amount: 1), Ingredient(name: "roasted red grapes", amount: 1), Ingredient(name: "double cream Brie", amount: 1), Ingredient(name: "caramelized onions", amount: 1), Ingredient(name: "Parmesan", amount: 1), Ingredient(name: "fresh wild arugula", amount: 1)]
    static let process = """
        1. Prepare dough.
        2. Assemble ingredients.
        3. Cook.
        4. Plate.
        """
    let recipe = Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipe.setImage(byUrl: "http://assets.kraftfoods.com/recipe_images/opendeploy/193146_640x428.jpg")
        guard let recipeView = recipe.recipePreview() else { return }
        view.backgroundColor = .white
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImage)
        view.addSubview(recipeView)
        NSLayoutConstraint.activate([
            recipeView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recipeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            recipeView.heightAnchor.constraint(equalToConstant: 200),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
