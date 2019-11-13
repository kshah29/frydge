//
//  Recipe.swift
//  Frydge
//
//  Created by Ian Costello on 11/7/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class Recipe {
    var id: Int = 0
    var title: String = ""
    var ingredientList: [Ingredient] = []
    var process: String = ""
    var notes: String = ""
    var image: UIImage?
    
    
    
    func setImage(byUrl url: String) {
//        Implement
    }
    func setImage(byName name: String) {
        self.image = UIImage(named: name)
    }
    
    private func recipePreview() -> UIView {
        let view = UIView()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 24, weight: .heavy)
            label.adjustsFontSizeToFitWidth = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(titleLabel)
        
        let recipeImage: UIImageView = {
            let iv = UIImageView(image: image)
            return iv
        }()
        view.addSubview(recipeImage)
        
        let titleLabelHeightConstraint1 = titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 92)
        let titleLabelHeightConstraint2 = titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -8)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8),
            titleLabelHeightConstraint1,
            titleLabelHeightConstraint2,
            
            recipeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            recipeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recipeImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8),
            recipeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
        titleLabelHeightConstraint1.priority = UILayoutPriority.init(1000)
        titleLabelHeightConstraint2.priority = UILayoutPriority.init(750)
        
        return view
    }
}

// Will likely pull out to own file later down the line; feels unnecessary for now. -Ian
struct Ingredient {
    var name: String = ""
    var amount: Int = 0
}
