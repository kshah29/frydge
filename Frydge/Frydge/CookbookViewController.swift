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

    let header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Cookbook"
        label.font = UIFont(name: "Comfortaa", size: 42)
        label.textColor = .black
        return label
    }()
    
    public func getFavoriteRecipe() -> [Recipe] {
        return RecipeStore.getRecipeList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.alpha = 0.5
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        let recipes = getFavoriteRecipe()
        var recipeViews: [UIView] = []

        for recipe in recipes {
            guard let recipeView = recipe.recipePreview() else { return }
            recipeViews.append(recipeView)
        }

        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
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
        
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
        
        }
 }
