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
    var process: [String] = []
    var notes: String?
    var imageUrl: String?
    var image: UIImage?
    var preppingTime: Int?
    var cookingTime: Int?
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
    init(id: Int, title: String, ingredientList: [Ingredient], process: [String], image: String?, prepTime: Int?, cookTime: Int?) {
        self.id = id
        self.title = title
        self.ingredientList = ingredientList
        self.process = process
        if image != nil {
            self.imageUrl = image
            self.setImage(byUrl: image!)
        }
        if prepTime != nil {
            self.preppingTime = prepTime
        }
        if cookTime != nil {
            self.cookingTime = cookTime
        }
        
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
    private var contentView = ContentView(frame: .zero)
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
    private var favoriteButtonBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.7
        return view
    }()
    
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
        sender.setImage(UIImage(named: "heartFilled.pdf"), for: .normal)
        sender.imageView?.contentMode = .scaleAspectFit
        favoriteButton.tintColor = #colorLiteral(red: 0.9990664124, green: 0.2145801485, blue: 0.2993823588, alpha: 1)
        sender.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
        recipe!.isFavorited = true
    }
    
    @objc func buttonDelRecipe(sender: UIButton!) {
        RecipeStore.delete(delRecipe: recipe!)
        sender.setImage(UIImage(named: "heart.pdf"), for: .normal)
        sender.imageView?.contentMode = .scaleAspectFit
        favoriteButton.tintColor = #colorLiteral(red: 0.9990664124, green: 0.2145801485, blue: 0.2993823588, alpha: 1)
        sender.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
        recipe!.isFavorited = false
    }
    
    
    func setupViews() {
        guard let image = image, let title = title else { return }
        setRecipeImage(image: image)
        setTitleLabel(title: title)
        guard let recipeImage = recipeImage, let titleLabel = titleLabel else { return }
        
        favoriteButtonBackground.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        favoriteButtonBackground.layer.cornerRadius = 5
        favoriteButtonBackground.layer.masksToBounds = true
        favoriteButtonBackground.layer.maskedCorners = [.layerMaxXMaxYCorner]
        favoriteButton.frame = CGRect(x:7, y:7, width:36, height:36)
        if(recipe!.isFavorited == false) {
            favoriteButton.setImage(UIImage(named: "heart.pdf"), for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
            favoriteButton.tintColor = #colorLiteral(red: 0.9990664124, green: 0.2145801485, blue: 0.2993823588, alpha: 1)
            favoriteButton.addTarget(self, action: #selector(buttonAddRecipe), for: .touchUpInside)
        }
        else {
            favoriteButton.setImage(UIImage(named: "heartFilled.pdf"), for: .normal)
            favoriteButton.imageView?.contentMode = .scaleAspectFit
            favoriteButton.tintColor = #colorLiteral(red: 0.9990664124, green: 0.2145801485, blue: 0.2993823588, alpha: 1)
            favoriteButton.addTarget(self, action: #selector(buttonDelRecipe), for: .touchUpInside)
        }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(recipeImage)
        contentView.gradientView = gradientView
        contentView.addSubview(gradientView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButtonBackground)
        contentView.addSubview(favoriteButton)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.constrainToContainer(container: self, padding: 0)
        NSLayoutConstraint.activate([
            recipeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImage.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            recipeImage.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            recipeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            gradientView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
        ])
        

        translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = CGFloat(5)
        contentView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    // For some reason the gradient layer must be positioned in this function. It doesn't get along well with AutoLayout otherwise.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.35).cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.7).cgColor]
        gradientView.setGradientBackground(colors: gradientColors, locations: [0.0, 0.3, 0.5])
    }
    
    class ContentView: UIView {
        var gradientView: UIView?
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.35).cgColor, UIColor(hue: 0, saturation: 0, brightness: 1.0, alpha: 0.8).cgColor]
            gradientView?.setGradientBackground(colors: gradientColors, locations: [0.0, 0.3, 0.5])
        }
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
