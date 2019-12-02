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
    var compiledRecipes: Bool = false
    var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
    var offset = 0;
    var query = "";
    
    @objc public func getRecipes() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.recipes = []
        self.compiledRecipes = false
        makeRequest(ingredientList: self.query.components(separatedBy: " "))
        while (self.compiledRecipes == false){
            // DO nothing - wait for it to populate
        }
        populateRecipes();
    }
    
    
    @objc func showRecipeViewController(_ sender: UITapGestureRecognizer) {
        for recipe in self.recipes! {
            if sender.view?.tag == recipe.id {
                let recipeVC = RecipeViewController(forRecipe: recipe)
                present(recipeVC, animated: true, completion: nil)
            }
        }
    }
    
    func dummyMakeRequest() {
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

    public func parseRecipeJSON (recipeJSON : [String: Any]){
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
        
        compiledRecipes = true
    }
    
    public func makeRequest (ingredientList : [String]) -> Void {
        let foodAPIURL = "https://api.spoonacular.com/recipes/complexSearch"
        let apiKey : String = "78eaab53fe1f4270932a90b65f805c64"
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
        
        let queryNumber = "10"
        
        let procedureParam = "&instructionsRequired=true"
        let recipeInfo = "&addRecipeInformation=true"
        
        let urlWithParams = foodAPIURL + "?apiKey=" + apiKey  + dietParam + intoleranceParam + "&includeIngredients=" + ingredientString + procedureParam + recipeInfo + "&number=" + queryNumber + "&offset=" + String(self.offset)
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
        self.offset = self.offset + 10;
    }
    
    func populateRecipes() {
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
            
            recipeView.tag = current_recipe.id
            let tapRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(self.showRecipeViewController(_:)))
            recipeView.addGestureRecognizer(tapRecipeGesture)
            
            let scrollContentHeight = CGFloat(220 * recipeViews.count + 50)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollContentHeight)
            
            i = i + 1
        }
        
        let load_more_button = UIButton(frame: CGRect(x: 20, y: 2200, width: 200, height: 30))
        load_more_button.backgroundColor = UIColor(red: 166/256, green: 165/256, blue: 162/256, alpha: 0.5)
        
        load_more_button.setTitle("...load more recipes", for: .normal)
        load_more_button.addTarget(self, action: #selector(getRecipes), for: .touchUpInside)
        
        scrollView.addSubview(load_more_button)
        NSLayoutConstraint.activate(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.populateRecipes()
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
        
        if searchbar.text != nil {
            self.query = searchbar.text!
            getRecipes()
        }
        else{
            getRecipes()
        }
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.offset = 0
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            self.query = searchBar.text!
            getRecipes()
        }
    }
}
