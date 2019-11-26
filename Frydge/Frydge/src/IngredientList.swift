//
//  PantryCells.swift
//  Frydge
//
//  Created by Brianna Tanusi on 11/26/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

class IngredientList {
    var ingredientList: [Ingredient] = []
    var selectedList: [Bool] = []
    
    func decreaseIngredientAmount(index:Int){
        if ingredientList[index].amount <= 1 {
            ingredientList[index].amount = 1
        }
        else{
            ingredientList[index].amount -= 1
        }
    }
    
    func increaseIngredientAmount(index:Int){
        ingredientList[index].amount += 1
    }
    
    func getIngredientName(index: Int) -> String{
        return ingredientList[index].name
    }
    
    func getIngredientAmount(index: Int) -> Int {
        return ingredientList[index].amount
    }
    
    func getIngredient(index: Int) -> Ingredient{
        return ingredientList[index]
    }
    
    func getSelect(index: Int) -> Bool{
        return selectedList[index]
    }
    
    func switchSelect(index:Int){
        selectedList[index] = !selectedList[index]
    }
    
    func addIngredient(ingredient: Ingredient){
        ingredientList.append(ingredient)
        selectedList.append(false)
    }
    
    func removeIngredient(index: Int){
        ingredientList.remove(at: index)
    }
    
    func removeSelectedIngredients(){
        if selectedList.count == 0{
            return
        }
        for i in (0...selectedList.count-1).reversed(){
            if selectedList[i] == true {
                ingredientList.remove(at: i)
            }
        }
        selectedList.removeAll(where: { $0 == true })
    }
    
    
    func ingredientListCount() -> Int{
        return ingredientList.count
    }
    
    func getSelectedIngredients() -> [Ingredient]{
        var selectedIngredientList: [Ingredient] = []
        if ingredientList.count == 0{
            return []
        }
        for i in 0..<(ingredientList.count-1){
            if selectedList[i] == true {
                selectedIngredientList.append(ingredientList[i])
            }
        }
        return selectedIngredientList
    }
    
    func copy(other: IngredientList){
        ingredientList = other.ingredientList
        selectedList = other.selectedList
    }
    
}
