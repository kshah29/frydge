//
//  RecipeViewController.swift
//  Frydge
//

import UIKit

class IngredientViewController: UIViewController {
    
    var ingredient: Ingredient?
    var backgroundImage: UIImageView?
    var titleView: UIView?
    
    //FIX THIS
    init(name: String) {
        super.init(nibName: nil, bundle: nil)
        self.ingredient?.name = name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sample Text"
        label.font = UIFont(name: "Comfortaa", size: 42)
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.alpha = 0.5
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(backgroundImage)

        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        NSLayoutConstraint.activate(list)
        
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
    }
    
    
}
    


