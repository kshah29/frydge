//
//  PantryCells.swift
//  Frydge
//
//  Created by Brianna Tanusi on 11/26/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class PantryListHeader: BaseCell {
    
    var pantryViewController: PantryViewController?

    let title: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = UIFont(name: "Comfortaa", size: 42)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ingredientNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Ingredient Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let addIngredientButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "add_icon.png")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let shoppingListButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("SHOPPING LIST", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 17)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    } ()
    
    let pantryListButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        button.setTitle("PANTRY LIST", for: .normal)
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 17)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    } ()
    
    let moveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("MOVE ITEM(S) TO PANTRY LIST", for: .normal)
        button.setTitle("MOVE ITEM(S) TO SHOPPING LIST", for: .selected)
        button.isSelected = false
        button.titleLabel?.font = UIFont(name: "Comfortaa", size: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.33, green:0.36, blue:0.40, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.adjustsImageWhenHighlighted = false
        return button
    } ()
    
    override func setupViews(){
        
        addSubview(title)
        addSubview(shoppingListButton)
        addSubview(pantryListButton)
        addSubview(ingredientNameTextField)
        addSubview(addIngredientButton)
        addSubview(moveButton)
        
        shoppingListButton.addTarget(self, action: #selector(PantryListHeader.showShoppingList(_:)), for: .touchUpInside)
        pantryListButton.addTarget(self, action: #selector(PantryListHeader.showPantryList(_:)), for: .touchUpInside)
        addIngredientButton.addTarget(self, action: #selector(PantryListHeader.addIngredient(_:)), for: .touchUpInside)
        moveButton.addTarget(self, action: #selector(PantryListHeader.move(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-10-[v1(30)]-22-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField, "v1":addIngredientButton ]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-[v1(==v0)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":shoppingListButton, "v1":pantryListButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":title]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":moveButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20@1000-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":title]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-110-[v0(50)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":pantryListButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-110-[v0(50)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":shoppingListButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(40)]-15-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v1":ingredientNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v1":addIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(40)]-15-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":moveButton]))
        
    }
    
    @objc func addIngredient(_ sender:UIButton!){
        if ingredientNameTextField.text!.isEmpty{
            return
        }
        pantryViewController?.addNewIngredient(ingredientName: ingredientNameTextField.text!.uppercased())
        ingredientNameTextField.text = ""
    }
    
    @objc func showShoppingList(_ sender:UIButton!){
        if !moveButton.isSelected{
            return
        }
        shoppingListButton.layer.borderColor = UIColor.black.cgColor
        shoppingListButton.layer.borderWidth = 2
        pantryListButton.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        pantryListButton.layer.borderWidth = 1
        moveButton.isSelected = false
        pantryViewController?.showShoppingList()
    }
    
    @objc func showPantryList(_ sender:UIButton!){
        if moveButton.isSelected{
            return
        }
        pantryListButton.layer.borderColor = UIColor.black.cgColor
        pantryListButton.layer.borderWidth = 2
        shoppingListButton.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        shoppingListButton.layer.borderWidth = 1
        moveButton.isSelected = true
        pantryViewController?.showPantryList()
    }
    
    @objc func move(_ sender:UIButton!){
        pantryViewController?.move()
    }
    
    func inputMode(){
        addIngredientButton.isHidden = false
        ingredientNameTextField.isHidden = false
        moveButton.isHidden = true
        reloadInputViews()
    }
    
    func moveMode(){
        addIngredientButton.isHidden = true
        ingredientNameTextField.isHidden = true
        moveButton.isHidden = false
        reloadInputViews()
    }
    
}


class PantryListCell: BaseCell {
    
    var pantryViewController: PantryViewController?
    
    var listIndex: Int = 0

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Ingredient"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "options_icon.png")
        button.setBackgroundImage(image, for: .normal)
        return button
    } ()
    
    let selectIngredientButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .selected)
        button.setTitleShadowColor(UIColor.clear, for: .normal)
        button.setTitleShadowColor(UIColor.clear, for: .selected)
        button.isSelected = false
        button.adjustsImageWhenHighlighted = false
        return button
    } ()
    
    override func setupViews(){
        addSubview(nameLabel)
        addSubview(optionsButton)
        addSubview(selectIngredientButton)
        
        optionsButton.addTarget(self, action: #selector(PantryListCell.optionsIngredient(_:)), for: .touchUpInside)
        selectIngredientButton.addTarget(self, action: #selector(PantryListCell.selectIngredient(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v2(25)]-15-[v0]-[v1(35)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":optionsButton, "v2":selectIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":optionsButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[v0(25)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":selectIngredientButton]))
    }
    
    @objc func optionsIngredient(_ sender:UIButton!){
        pantryViewController?.showIngredientViewController(index: listIndex)
    }
    @objc func selectIngredient(_ sender:UIButton!){
        if selectIngredientButton.isSelected == true {
            selectIngredientButton.isSelected = false
        }
        else{
            selectIngredientButton.isSelected = true
        }
        pantryViewController?.selectIngredient(index: listIndex)
    }
    
}


class BaseCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("not implemented")
    }
    
    func setupViews(){
    }
}
