//
//  PantryCells.swift
//  Frydge
//
//  Created by Brianna Tanusi on 11/26/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

var shoppingList = IngredientList()
var pantryList = IngredientList()

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isShoppingList = true
    var ingredients = IngredientList()
    var header : PantryListHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //background image setup
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: collectionView.topAnchor)
        backgroundImage.leftAnchor.constraint(equalTo: collectionView.leftAnchor)
        backgroundImage.rightAnchor.constraint(equalTo: collectionView.rightAnchor)
        backgroundImage.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        
        collectionView?.backgroundView = backgroundImage
        collectionView?.backgroundColor = UIColor.white
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        //register cells & header
        collectionView?.register(PantryListCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(PantryListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.ingredientListCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //display list
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PantryListCell
        listCell.nameLabel.text = ingredients.getIngredientName(index:indexPath.item) + " - " + String(ingredients.getIngredientAmount(index: indexPath.item))
        listCell.pantryViewController = self
        listCell.listIndex = indexPath.item
        listCell.selectIngredientButton.isSelected = ingredients.getSelect(index: indexPath.item)
        return listCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //display header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! PantryListHeader
        header?.pantryViewController = self
        header?.backgroundColor = UIColor.white
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    //change lists
    func addNewIngredient(ingredientName: String){
        if(isShoppingList){
            shoppingList.addIngredient(ingredient: Ingredient(name: ingredientName, amount: 1))
            ingredients.copy(other: shoppingList)
        }
        else{
            pantryList.addIngredient(ingredient: Ingredient(name: ingredientName, amount: 1))
            ingredients.copy(other: pantryList)
        }
        collectionView?.reloadData()
    }
    
    func move(){
        //if we're currently looking at shopping list
        if(isShoppingList){
            for i in 0..<(shoppingList.ingredientListCount()){
                if shoppingList.getSelect(index: i){
                    pantryList.addIngredient(ingredient: shoppingList.getIngredient(index: i))
                }
            }
            shoppingList.removeSelectedIngredients()
            ingredients.copy(other: shoppingList)
        }
        else{
            for i in 0..<(pantryList.ingredientListCount()){
                if pantryList.getSelect(index: i){
                    shoppingList.addIngredient(ingredient: pantryList.getIngredient(index: i))
                }
            }
            pantryList.removeSelectedIngredients()
            ingredients.copy(other: pantryList)
        }
        showHeader()
        collectionView?.reloadData()
    }
    
    func removeIngredient(index: Int){
        if(isShoppingList){
            shoppingList.removeIngredient(index: index)
            ingredients.copy(other: shoppingList)
        }
        else{
            pantryList.removeIngredient(index: index)
            ingredients.copy(other: pantryList)
        }
        collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func showHeader(){
        if ingredients.selectedList.contains(true){
            header?.moveMode()
        }
        else{
            header?.inputMode()
        }
    }
    
    func selectIngredient(index: Int){
        if(isShoppingList){
            shoppingList.switchSelect(index: index)
            ingredients.copy(other: shoppingList)
        }
        else{
            pantryList.switchSelect(index: index)
            ingredients.copy(other: pantryList)
        }
        showHeader()
        collectionView?.reloadData()
    }
    
    func showShoppingList(){
        pantryList.copy(other: ingredients)
        ingredients.copy(other: shoppingList)
        isShoppingList = true
        showHeader()
        collectionView?.reloadData()
    }
    
    func showPantryList(){
        shoppingList.copy(other: ingredients)
        ingredients.copy(other: pantryList)
        isShoppingList = false
        showHeader()
        collectionView?.reloadData()
    }
    
    func showIngredientViewController(index: Int) {
        let ingredientVC = IngredientViewController(input: ingredients.getIngredient(index: index), pantry: self, index: index)
        present(ingredientVC, animated: true, completion: nil)
    }
    
    func searchWithPantry(){
        let searchList = ingredients.getSelectedIngredients().getIngredientsListForSearch()
        print(searchList)
        let rsVC = RecipeSearchViewController()
        var input = ""
        for i in searchList{
            input += i + " "
        }
        rsVC.searchbar.text = input.lowercased()
        present(rsVC, animated: true, completion: nil)
    }
    
}






