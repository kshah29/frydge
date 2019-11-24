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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.frame = view.frame
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        let fadeView = UIView(frame: backgroundImage.frame)
        fadeView.backgroundColor = .white
        fadeView.alpha = 0.5
        backgroundImage.addSubview(fadeView)
        view.addSubview(backgroundImage)
        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        guard let ingredient = ingredient else { return }

        
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
        label.text = ingredient?.name
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

