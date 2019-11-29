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

    var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
    var recipes: [Recipe]? = nil
    var recipeViews: [UIView] = []
    
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
    
    @objc func showRecipeViewController(_ sender: UITapGestureRecognizer) {
        let recipes = getFavoriteRecipe()
        for recipe in recipes {
            if sender.view?.tag == recipe.id {
                let recipeVC = RecipeViewController(forRecipe: recipe)
                present(recipeVC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.viewDidLoad()
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

        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(backgroundImage)
        
        let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .white
            v.addSubview(backgroundImage)
            return v
        }()
        
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true

        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        var i = 0
        for (index, recipeView) in recipeViews.enumerated() {
            scrollView.addSubview(recipeView)

            let top = (220 * i)
            list.append(recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            let scrollContentHeight = CGFloat(220 * recipeViews.count)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollContentHeight)

            i = i + 1
            

            recipeView.tag = recipes[index].id
            let tapRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(self.showRecipeViewController(_:)))
            recipeView.addGestureRecognizer(tapRecipeGesture)
        }
    
        NSLayoutConstraint.activate(list)
        
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
        
        }
 }
