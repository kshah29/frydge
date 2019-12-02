//
//  RecipeViewController.swift
//  Frydge
//

import UIKit

class IngredientViewController: UIViewController {
    
    private var ingredient: Ingredient
    private var pantryVC: PantryViewController
    private var index: Int
    
    init(input: Ingredient, pantry: PantryViewController, index: Int) {
        self.ingredient = input
        self.pantryVC = pantry
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sample Text"
        label.font = UIFont(name: "Comfortaa", size: 50)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1"
        label.font = UIFont(name: "Comfortaa", size: 35)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = button.frame.size.height/2
        button.clipsToBounds = true
        button.contentMode = UIView.ContentMode.center
        let image = UIImage(named: "plus_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "minus_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "trash_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
            backgroundImage.contentMode = .scaleAspectFill
            backgroundImage.alpha = 0.5
            backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = UIColor(white: 1, alpha: 1)
        
        view.addSubview(backgroundImage)

        let list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        NSLayoutConstraint.activate(list)
        header.text = ingredient.name
        view.addSubview(header)
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        header.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -250.0).isActive = true
        
        amount.text = String(ingredient.amount)
        view.addSubview(amount)
        amount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        amount.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        
        view.addSubview(plusButton)
        plusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100.0).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        plusButton.addTarget(self, action: #selector(self.plusButtonHandler(_:)), for: .touchUpInside)
        
        view.addSubview(minusButton)
        minusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100.0).isActive = true
        minusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        minusButton.addTarget(self, action: #selector(self.minusButtonHandler(_:)), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50.0).isActive = true
        deleteButton.addTarget(self, action: #selector(self.deleteButtonHandler(_:)), for: .touchUpInside)
        
    }
    
    @objc private func plusButtonHandler(_ sender:UIButton!){
        ingredient.amount += 1
        amount.text = String(ingredient.amount)
        pantryVC.getIngredientsList().increaseIngredientAmount(index: index)
        if pantryVC.checkShowingShoppingList() {
            pantryVC.getShoppingList().copy(other: pantryVC.getIngredientsList())
        }
        else{
            pantryVC.getPantryList().copy(other: pantryVC.getIngredientsList())
        }
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    
    @objc private func minusButtonHandler(_ sender:UIButton!){
        if(ingredient.amount <= 1){
            ingredient.amount = 1
        }
        else{
            ingredient.amount -= 1
        }
        amount.text = String(ingredient.amount)
        pantryVC.getIngredientsList().decreaseIngredientAmount(index: index)
        if pantryVC.checkShowingShoppingList() {
            pantryVC.getShoppingList().copy(other: pantryVC.getIngredientsList())
        }
        else{
            pantryVC.getPantryList().copy(other: pantryVC.getIngredientsList())
        }
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    
    @objc private func deleteButtonHandler(_ sender:UIButton!){
        pantryVC.removeIngredient(index: index)
    }
}
    


