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
        label.font = UIFont(name: "Comfortaa", size: 42)
        label.textColor = .black
        return label
    }()
    
    let amount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "1"
        label.font = UIFont(name: "Comfortaa", size: 25)
        label.textColor = .black
        return label
    }()
    
    let amountField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Amount"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Plus", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    @objc func plusButtonHandler(_ sender:UIButton!){
        ingredient.amount += 1
        amount.text = String(ingredient.amount)
        pantryVC.ingredients.increaseIngredientAmount(index: index)
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Minus", for: .normal)
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
        pantryVC.collectionView?.reloadData()
        view.reloadInputViews()
    }
    

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
        header.text = ingredient.name
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
        
        amount.text = String(ingredient.amount)
        view.addSubview(amount)
        amount.translatesAutoresizingMaskIntoConstraints = false
        amount.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        amount.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        
        view.addSubview(amountField)
        amountField.translatesAutoresizingMaskIntoConstraints = false
        amountField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50.0).isActive = true
        amountField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100.0).isActive = true
        
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100.0).isActive = true
        plusButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        plusButton.addTarget(self, action: #selector(self.plusButtonHandler(_:)), for: .touchUpInside)
        
        view.addSubview(minusButton)
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        minusButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200.0).isActive = true
        minusButton.addTarget(self, action: #selector(self.minusButtonHandler(_:)), for: .touchUpInside)
        

    }
    
    
}
    


