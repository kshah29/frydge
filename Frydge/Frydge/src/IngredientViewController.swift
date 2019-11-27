//
//  RecipeViewController.swift
//  Frydge
//

import UIKit

class IngredientViewController: UIViewController {
    
    var ingredient: Ingredient
    var pantryVC: PantryViewController
    var index: Int
    var backgroundImage: UIImageView?
    var titleView: UIView?
    
    init(input: Ingredient, pantry: PantryViewController, index: Int) {
        self.ingredient = input
        self.pantryVC = pantry
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let header: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sample Text"
        label.font = UIFont(name: "Comfortaa", size: 50)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1"
        label.font = UIFont(name: "Comfortaa", size: 35)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Plus", for: .normal)
        button.layer.cornerRadius = button.frame.size.height/2
        button.clipsToBounds = true
        button.contentMode = UIView.ContentMode.center
        let image = UIImage(named: "plus_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    @objc func plusButtonHandler(_ sender:UIButton!){
        ingredient.amount += 1
        amount.text = String(ingredient.amount)
        pantryVC.ingredients.increaseIngredientAmount(index: index)
        if pantryVC.isShoppingList {
            shoppingList.copy(other: pantryVC.ingredients)
        }
        else{
            pantryList.copy(other: pantryVC.ingredients)
        }
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("Minus", for: .normal)
        let image = UIImage(named: "minus_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    @objc func minusButtonHandler(_ sender:UIButton!){
        if(ingredient.amount <= 1){
            ingredient.amount = 1
        }
        else{
            ingredient.amount -= 1
        }
        amount.text = String(ingredient.amount)
        pantryVC.ingredients.decreaseIngredientAmount(index: index)
        if pantryVC.isShoppingList {
            shoppingList.copy(other: pantryVC.ingredients)
        }
        else{
            pantryList.copy(other: pantryVC.ingredients)
        }
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitle("delete", for: .normal)
        let image = UIImage(named: "trash_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    @objc func deleteButtonHandler(_ sender:UIButton!){
        pantryVC.removeIngredient(index: index)
        pantryVC.collectionView?.reloadData()
    }
    

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
        header.translatesAutoresizingMaskIntoConstraints = false
        //header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        //header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
        header.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        header.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -250.0).isActive = true
        
        amount.text = String(ingredient.amount)
        view.addSubview(amount)
        amount.translatesAutoresizingMaskIntoConstraints = false
        amount.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        amount.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        //amount.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
       // amount.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100.0).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        //plusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100.0).isActive = true
        //plusButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        plusButton.addTarget(self, action: #selector(self.plusButtonHandler(_:)), for: .touchUpInside)
        
        view.addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100.0).isActive = true
        minusButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0).isActive = true
        //minusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        //minusButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        minusButton.addTarget(self, action: #selector(self.minusButtonHandler(_:)), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 50.0).isActive = true
        //minusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        //minusButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        deleteButton.addTarget(self, action: #selector(self.deleteButtonHandler(_:)), for: .touchUpInside)

    }
    
    
}
    


