//
//  Recipe.swift
//  Frydge
//
//  Created by Ian Costello on 11/7/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit


// MARK:- Recipe Class
/**
 The Recipe class contains a number of variables that describe a given recipe. Recipe objects are used throughout the app to display search results and to store information about the user's favorites.
 - You may generate a preview from a Recipe object, displaying the recipe's image and title. This is used to show search results and favorites.
 */
class Recipe {
    var id: Int = 0
    var title: String = ""
    var ingredientList: [Ingredient] = []
    var process: String = ""
    var notes: String?
    var image: UIImage?
    var preppingTime: Int? = 10
    var cookingTime: Int? = 10
    var isFavorited: Bool = false
    
    /**
    Initializes a new recipe from the title, ingredients, process, and optionally image specified.

    - Parameters:
        - id: A unique ID for the dish, taken from the Spoonacular API
        - title: The name of the dish
        - ingredientList: Ingredients needed for the dish
        - process: A string describing the instructions to create the dish
        - image: A string naming an image from assets (used primarily for testing with dummy data)
        - isFavorited: Whether or not the user has favorited this recipe to be displayed in Cookbook
        

    - Returns: A Recipe object, the foundation of many features in our app
    */
    init(id: Int, title: String, ingredientList: [Ingredient], process: String, image: String?) {
        self.id = id
        self.title = title
        self.ingredientList = ingredientList
        self.process = process
        if image != nil {
            self.setImage(byUrl: image!)
        }
//        if prepTime != nil {
//            self.preppingTime = prepTime
//        }
//        if cookTime != nil {
//            self.cookingTime = cookTime
//        }
        
    }
    
    /**
    Sets a Recipe object's image from the provided URL. This URL will generally be taken from an API query.

    - Parameters:
        - url: A string representing the URL to query for an image.
     
     - Returns: No return value
    */
    func setImage(byUrl url: String) {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            self.image = image
        }
    }
    
    /**
    Sets a Recipe object's image from the a provided image filename. Used primarily for testing, as images should generally be pulled from the API.

    - Parameters:
        - name: A string that refers to a file in the project's assets.
     
     - Returns: No return value
    */
    func setImage(byName name: String) {
        self.image = UIImage(named: name)
    }
    
    /**
     Get a UIView that displays the Recipe object's image and title. This is useful for maintaining consistency between different pages that display recipe previews, such as the search results page and the favorited recipes (Cookbook) page. If the Recipe does not have an image, it cannot have a graphical preview, so this returns nil.
     
     - Returns: An optional  UIView, which displays the Recipe object's image and title. If the object calling this function does not have an image, the return value is nil.
     */
    /// - tag: recipePreview
    func recipePreview() -> UIView? {
        guard let image = image else { return nil }
        let view = RecipeView(title: title, image: image, recipe: self)
        view.setupViews()
        return view
    }
}





// MARK:- RecipeView Class
/**
 This class is used to layout the views used in generating a Recipe object's preview.
 */
class RecipeView: UIView {
    private var image: UIImage?
    private var recipeImage: UIImageView?
    private var recipe: Recipe?
    private func setRecipeImage(image: UIImage) {
        let iv = UIImageView(image: image)
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        recipeImage = iv
    }
    
    private var title: String?
    private var titleLabel: UILabel?
    private func setTitleLabel(title: String) {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = title
        label.textColor = .black
        label.font = UIFont(name: "Comfortaa", size: 28)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        titleLabel = label
    }
    
    private var gradientView = UIView()
    private var favoriteButton  = UIButton(type: .custom)
    
    /**
     Initializes a RecipeView, a class that Recipe depends on to generate a recipe preview. After initializing the RecipeView object,  [setupViews](x-source-tag://setupViews) must be called to set up the UI.
     
     - Parameters:
        - title: The name of the recipe
        - image: The recipe image displayed in the view
     */
    init(title: String, image: UIImage, recipe: Recipe) {
        super.init(frame: .zero)
        
        self.title = title
        self.image = image
        self.recipe = recipe
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     

    /**
     Sets the RecipeView object's subviews, including recipeImage, gradientView, and titleLabel. This should be called after initializing a RecipeView.
     */
    /// - tag: setupViews
    
    @objc func buttonAddRecipe(sender: UIButton!) {
        RecipeStore.delete(delRecipe: recipe!)
        RecipeStore.add(addRecipe: recipe!)
        sender.setImage(UIImage(named: "heartfilled.png"), for: .normal)
        sender.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
        recipe!.isFavorited = true
    }
    
    @objc func buttonDelRecipe(sender: UIButton!) {
        RecipeStore.delete(delRecipe: recipe!)
        sender.setImage(UIImage(named: "heart.jpg"), for: .normal)
        sender.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
        recipe!.isFavorited = false
    }
    
    
    func setupViews() {
        guard let image = image, let title = title else { return }
        setRecipeImage(image: image)
        setTitleLabel(title: title)
        guard let recipeImage = recipeImage, let titleLabel = titleLabel else { return }
        
        favoriteButton.frame = CGRect(x:5, y:5, width:35, height:35)
        if(recipe!.isFavorited == false) {
            favoriteButton.setImage(UIImage(named: "heart.jpg"), for: .normal)
            favoriteButton.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
        }
        else {
            favoriteButton.setImage(UIImage(named: "heartfilled.png"), for: .normal)
            favoriteButton.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
        }
        
        addSubview(recipeImage)
        addSubview(gradientView)
        addSubview(titleLabel)
        addSubview(favoriteButton)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImage.topAnchor.constraint(equalTo: topAnchor),
            recipeImage.leftAnchor.constraint(equalTo: leftAnchor),
            recipeImage.rightAnchor.constraint(equalTo: rightAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
        ])
        

        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = CGFloat(5)
    }
    
    // For some reason the gradient layer must be positioned in this function. It doesn't get along well with AutoLayout otherwise.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.35).cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.7).cgColor]
        gradientView.setGradientBackground(colors: gradientColors, locations: [0.0, 0.2, 0.5])
    }
}






// MARK:- Ingredient Class
struct Ingredient {
    var name: String = ""
    var amount: Int = 0
    
    init(name: String, amount: Int) {
        self.name = name
        self.amount = amount
    }
}





// MARK:- UIView extension
extension UIView {
    func setGradientBackground(colors: [CGColor], locations: [NSNumber]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
