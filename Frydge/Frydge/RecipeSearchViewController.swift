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
    let current_query: String? = nil
    var recipes: [Recipe]? = nil
    
    public func getRecipes() {

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
    
    @objc func buttonAddRecipe(sender: UIButton!) {
        for recipe in self.recipes! {
            if sender.tag == recipe.id {
                RecipeStore.delete(delRecipe: recipe)
                RecipeStore.add(addRecipe: recipe)
            }
        }
        sender.setTitle("★", for: .normal)
        sender.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
    }
    
    @objc func buttonDelRecipe(sender: UIButton!) {
        for recipe in self.recipes! {
            if sender.tag == recipe.id {
                RecipeStore.delete(delRecipe: recipe)
            }
        }
        sender.setTitle("☆", for: .normal)
        sender.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
    }

    private func parseRecipeJSON (recipeJSON : [String: Any]){
        let results = recipeJSON["results"] as? [Any]
        
        for element in results! {
            
            if let element = element as? [String:Any] {
                let title = element["title"]
                print("TITLE")
                print(title)
                
                let nid = element["id"] as? Int
                print(nid)
                
                let prepTime = element["preparationMinutes"]
                print(prepTime)
                let cookTime = element["cookingMinutes"]
                print(cookTime)
                
                let imageURL = element["image"]
                print(imageURL)
                
                let instruction = element["analyzedInstructions"] as? [Any]
                let procedure = instruction?[0] as? [String:Any]
                
                let steps = procedure?["steps"] as? [Any] ?? []
                var num : Int = 1
                var process : String = ""
                for eachStep in steps{
                    if let eachStep = eachStep as? [String:Any]{
                        let step = eachStep["step"] as? String
                        let pre = String(num) + ". "
                        let end = step! + "\n"
                        process = process + pre + end
                    }
                    num = num + 1
                }
                print(process)
                
                self.recipes?.append(Recipe(id: nid ?? 0, title: title as! String, ingredientList: [], process: process, image: imageURL as! String))
            }
        }
    }
    
    private func makeRequest (ingredientList : [String]) -> Void {
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

                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]

                        self.parseRecipeJSON(recipeJSON: parsedData)
                        
                    } catch let error as NSError {
                              print("Error Parsing Json \(error)" )
                    }
                }
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        var recipeViews: [UIView] = []

        getRecipes()
        if self.recipes != nil {
            for recipe in self.recipes! {
                guard let recipeView = recipe.recipePreview() else { return }
                recipeViews.append(recipeView)
            }
        }

        view.backgroundColor = .white
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
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("Handle search")
    }
}
