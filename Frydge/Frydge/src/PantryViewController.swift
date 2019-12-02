//
//  PantryCells.swift
//  Frydge
//
//  Created by Brianna Tanusi on 11/26/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var showingShoppingList = true
    private var ingredientsList = IngredientList()
    public var shoppingList = IngredientList()
    public var pantryList = IngredientList()
    private var header : PantryListHeader?
    
    public func checkShowingShoppingList() -> Bool{
        return showingShoppingList
    }
    
    public func getIngredientsList() -> IngredientList{
        return ingredientsList
    }
    
    public func getShoppingList() -> IngredientList{
        return shoppingList
    }
    
    public func getPantryList() -> IngredientList{
        return pantryList
    }
    
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
        return ingredientsList.ingredientListCount()
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
        listCell.nameLabel.text = ingredientsList.getIngredientName(index:indexPath.item) + " - " + String(ingredientsList.getIngredientAmount(index: indexPath.item))
        listCell.pantryViewController = self
        listCell.setListIndex(index: indexPath.item)
        listCell.selectIngredientButton.isSelected = ingredientsList.getSelect(index: indexPath.item)
        return listCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //display header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as? PantryListHeader
        header?.pantryViewController = self
        header?.backgroundColor = UIColor.white
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 230)
    }
    
    //change lists
    func addNewIngredient(ingredientName: String){
        if(showingShoppingList){
            shoppingList.addIngredient(ingredient: Ingredient(name: ingredientName, amount: 1))
            ingredientsList.copy(other: shoppingList)
        }
        else{
            pantryList.addIngredient(ingredient: Ingredient(name: ingredientName, amount: 1))
            ingredientsList.copy(other: pantryList)
        }
        collectionView?.reloadData()
    }
    
    func moveIngredients(){
        //if we're currently looking at shopping list
        if(showingShoppingList){
            for i in 0..<(shoppingList.ingredientListCount()){
                if shoppingList.getSelect(index: i){
                    pantryList.addIngredient(ingredient: shoppingList.getIngredient(index: i))
                }
            }
            shoppingList.removeSelectedIngredients()
            ingredientsList.copy(other: shoppingList)
        }
        else{
            for i in 0..<(pantryList.ingredientListCount()){
                if pantryList.getSelect(index: i){
                    shoppingList.addIngredient(ingredient: pantryList.getIngredient(index: i))
                }
            }
            pantryList.removeSelectedIngredients()
            ingredientsList.copy(other: pantryList)
        }
        showHeader()
        collectionView?.reloadData()
    }
    
    func removeIngredient(index: Int){
        if(showingShoppingList){
            shoppingList.removeIngredient(index: index)
            ingredientsList.copy(other: shoppingList)
        }
        else{
            pantryList.removeIngredient(index: index)
            ingredientsList.copy(other: pantryList)
        }
        showHeader()
        collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func showHeader(){
        if ingredientsList.anySelected(){
            header?.selectedMode()
        }
        else{
            header?.inputMode()
        }
    }
    
    func selectIngredient(index: Int){
        if(showingShoppingList){
            shoppingList.switchSelect(index: index)
            ingredientsList.copy(other: shoppingList)
        }
        else{
            pantryList.switchSelect(index: index)
            ingredientsList.copy(other: pantryList)
        }
        showHeader()
        collectionView?.reloadData()
    }
    
    func showShoppingList(){
        pantryList.copy(other: ingredientsList)
        ingredientsList.copy(other: shoppingList)
        showingShoppingList = true
        showHeader()
        collectionView?.reloadData()
    }
    
    func showPantryList(){
        shoppingList.copy(other: ingredientsList)
        ingredientsList.copy(other: pantryList)
        showingShoppingList = false
        showHeader()
        collectionView?.reloadData()
    }
    
    func showIngredientViewController(index: Int) {
        let ingredientVC = IngredientViewController(input: ingredientsList.getIngredient(index: index), pantry: self, index: index)
        present(ingredientVC, animated: true, completion: nil)
    }
    
    func searchWithPantry(){
        let searchList = ingredientsList.getSelectedIngredients().getIngredientsListForSearch()
        let rsVC = RecipeSearchViewController()
        var input = ""
        for i in searchList{
            input += i + " "
        }
        rsVC.searchbar.text = input.lowercased()
        present(rsVC, animated: true, completion: nil)
    }
    
}






