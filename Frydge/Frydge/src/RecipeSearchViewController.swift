//
//  RecipeSearchViewController.swift
//  Frydge
//
//  Created by Natasha Sarkar on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit


class RecipeSearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchbar = UISearchBar(frame: CGRect(x: 10, y: 50, width: 390.0, height: 50.0))
    var recipes: [Recipe]? = nil
    var recipeViews: [UIView] = []
    var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
    
    public func getRecipes(query: String) {
        dummyMakeRequest()
        populateRecipes()
    }
    
    @objc func buttonAddRecipe(sender: UIButton!) {
        for recipe in self.recipes! {
            if sender.tag == recipe.id {
                RecipeStore.delete(delRecipe: recipe)
                RecipeStore.add(addRecipe: recipe)
            }
        }
        sender.setTitle("★", for: .normal)
        sender.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
        
        // FIXME:- I did this really janky hack to update the Cookbook view controller, but it's probably pretty bad for performance.
        if let tabController = self.tabBarController {
            for (index, vc) in tabController.viewControllers?.enumerated() ?? [].enumerated() {
                if let _ = vc as? CookbookViewController {
                    let cb = CookbookViewController()
                    cb.tabBarItem.title = "Cookbook"
                    cb.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)], for: .normal)
                    cb.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    tabController.viewControllers?[index] = cb
                }
            }
        }
    }
    
    @objc func buttonDelRecipe(sender: UIButton!) {
        for recipe in self.recipes! {
            if sender.tag == recipe.id {
                RecipeStore.delete(delRecipe: recipe)
            }
        }
        sender.setTitle("☆", for: .normal)
        sender.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
        
        // FIXME:- I did this really janky hack to update the Cookbook view controller, but it's probably pretty bad for performance.
        if let tabController = self.tabBarController {
            for (index, vc) in tabController.viewControllers?.enumerated() ?? [].enumerated() {
                if let _ = vc as? CookbookViewController {
                    let cb = CookbookViewController()
                    cb.tabBarItem.title = "Cookbook"
                    cb.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)], for: .normal)
                    cb.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                    tabController.viewControllers?[index] = cb
                }
            }
        }
    }
    
    @objc func showRecipeViewController(_ sender: UITapGestureRecognizer) {
        for recipe in self.recipes! {
            if sender.view?.tag == recipe.id {
                let recipeVC = RecipeViewController(forRecipe: recipe)
                present(recipeVC, animated: true, completion: nil)
            }
        }
    }
    
    private func dummyMakeRequest() {
        let ingredients = [Ingredient(name: "some kind of dough", amount: 1), Ingredient(name: "roasted red grapes", amount: 1), Ingredient(name: "double cream Brie", amount: 1), Ingredient(name: "caramelized onions", amount: 1), Ingredient(name: "Parmesan", amount: 1), Ingredient(name: "fresh wild arugula", amount: 1)]
        let process = """
            1. Prepare dough.
            2. Assemble ingredients.
            3. Cook.
            4. Plate.
            """
        
        let ingredients2: [Ingredient] = []
        let process2 = ""

        var recipes = [
            Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process,
                   image: "https://assets.kraftfoods.com/recipe_images/opendeploy/193146_640x428.jpg"),
            Recipe(id: 1, title: "Untitled Thing 2", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg")
        ]
        
        for i in 2...10 {
            recipes.append(
                Recipe(id: i, title: "Another Thing", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg")
            )
        }
            
        self.recipes = recipes
    }

    public func makeRequest (ingredientList : [String]) -> String {
        let foodAPIURL = "https://api.spoonacular.com/recipes/complexSearch"
        let apiKey : String = "1369e5b47d744efa9885c6ecae9f9be4"
        var ingredientString : String = ""
        
        for ingredient in ingredientList {
            if ingredientString == ""{
                ingredientString = ingredient
            } else {
                ingredientString = ingredientString + ",+" + ingredient
            }
        }
        
        let diet = PersonalData.getDietaryRestrictions()
        var dietParam = ""
        if (diet != ""){
            dietParam = "&diet=" + diet
        }
        
        let intolerance = PersonalData.getIntoleranceString()
        var intoleranceParam = ""
        if (intolerance != ""){
            intoleranceParam += "&intolerances" + intolerance
        }
        
        let queryNumber = "2"
        
        let procedureParam = "&instructionsRequired=true"
        let recipeInfo = "&addRecipeInformation=true"
        
        let urlWithParams = foodAPIURL + "?apiKey=" + apiKey  + dietParam + intoleranceParam + "&includeIngredients=" + ingredientString + procedureParam + recipeInfo + "&number=" + queryNumber
        print(urlWithParams)
        
        var dataStr : String = ""
        
        // Excute HTTP Request
        let url = URL(string: urlWithParams)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                    dataStr = dataString
                }
            }
        }
        task.resume()
        
        return dataStr
    }
    
    func populateRecipes() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        super.viewDidLoad()
        
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
        view.addSubview(searchbar)
        
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

        if self.recipes != nil {
            self.recipeViews = []
            for recipe in self.recipes! {
                guard let recipeView = recipe.recipePreview() else { return }
                recipeViews.append(recipeView)
            }
        }
        var i = 0
        for recipeView in recipeViews {
            
            // add the recipe to the view
            scrollView.addSubview(recipeView)
            let top = (220 * i)
            list.append(recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            // add the favorite button to the view, tagged with the recipe's id
            let current_recipe = (self.recipes)![i]
            let y_coord = (220 * i) + 10
            let button = UIButton(frame: CGRect(x: 355, y: y_coord, width: 30, height: 30))
            button.tag = current_recipe.id
            button.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
            
            recipeView.tag = current_recipe.id
            let tapRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(self.showRecipeViewController(_:)))
            recipeView.addGestureRecognizer(tapRecipeGesture)
            
            let current_favorites = RecipeStore.getRecipeList()
            var in_favorites = false
            for favorite in current_favorites {
                if favorite.id == current_recipe.id {
                    // this recipe is already in favorites, clicking on the button should remove it
                    button.setTitle("★", for: .normal)
                    button.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
                    in_favorites = true
                }
            }
            
            if !in_favorites {
                button.setTitle("☆", for: .normal)
                button.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
            }
            scrollView.addSubview(button)
            
            let scrollContentHeight = CGFloat(220 * recipeViews.count)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollContentHeight)
            
            i = i + 1
        }
    
        NSLayoutConstraint.activate(list)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        
        getRecipes(query: "")
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            getRecipes(query: searchBar.text!)
        }
    }
}