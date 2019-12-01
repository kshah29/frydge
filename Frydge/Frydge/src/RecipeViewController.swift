//
//  RecipeViewController.swift
//  Frydge
//
//  Created by Ian Costello on 11/14/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe?
    var backgroundImage: UIImageView?
    var titleView: UIView?
    
    init(forRecipe recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        guard let recipe = recipe else { return }
        if recipe.image != nil {
            backgroundImage = UIImageView(image: recipe.image)
            if let backgroundImage = backgroundImage {
                backgroundImage.frame = view.frame
                backgroundImage.contentMode = .scaleAspectFill
                
//                let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//                frost.frame = backgroundImage.frame
//                backgroundImage.insertSubview(frost, at: 0)
                
                let fadeView = UIView(frame: backgroundImage.frame)
                fadeView.backgroundColor = .white
                fadeView.alpha = 0.5
                backgroundImage.addSubview(fadeView)
                view.addSubview(backgroundImage)
            }
        }
        
        titleView = createTitleView()
        titleView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleView!)
        NSLayoutConstraint.activate([
            titleView!.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleView!.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleView!.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            titleView!.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func createTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.8
        
        let label = UILabel()
        label.text = recipe?.title
//        print(recipe?.title)
        label.font = UIFont(name: "Comfortaa", size: 35)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.constrainToContainer(container: view, padding: 10)
        return view
    }
}

extension UIView {
    func constrainToContainer(container: UIView, padding: CGFloat?) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: padding ?? 0),
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding ?? 0),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -1 * (padding ?? 0)),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * (padding ?? 0))
        ])
    }
}
