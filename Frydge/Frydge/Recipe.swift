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
class Recipe {
    var id: Int = 0
    var title: String = ""
    var ingredientList: [Ingredient] = []
    var process: String = ""
    var notes: String?
    var image: UIImage?
    
    init(id: Int, title: String, ingredientList: [Ingredient], process: String, image: String?) {
        self.id = id
        self.title = title
        self.ingredientList = ingredientList
        self.process = process
        if image != nil {
            self.setImage(byUrl: image!)
        }
    }
    
    func setImage(byUrl url: String) {
        let url = URL(string: url)
        let data = try? Data(contentsOf: url!)

        if let imageData = data {
            let image = UIImage(data: imageData)
            self.image = image
        }
    }
    
    func setImage(byName name: String) {
        self.image = UIImage(named: name)
    }
    func recipePreview() -> UIView? {
        guard let image = image else { return nil }
        let view = RecipeView(title: title, image: image)
        view.setupViews()
        return view
    }
}





// MARK:- RecipeView Class
class RecipeView: UIView {
    private var image: UIImage?
    private var recipeImage: UIImageView?
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
    
    init(title: String, image: UIImage) {
        super.init(frame: .zero)
        
        self.title = title
        self.image = image
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        guard let image = image, let title = title else { return }
        setRecipeImage(image: image)
        setTitleLabel(title: title)
        guard let recipeImage = recipeImage, let titleLabel = titleLabel else { return }
        
        addSubview(recipeImage)
        addSubview(gradientView)
        addSubview(titleLabel)
        
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
