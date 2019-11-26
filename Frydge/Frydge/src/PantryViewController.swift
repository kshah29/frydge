//
//  RecipeSearchViewController.swift
//  Frydge
//

import UIKit

var shoppingList = IngredientList()
var pantryList = IngredientList()

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isShoppingList = true;
    var ingredients = IngredientList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //background image setup
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        collectionView?.backgroundView = backgroundImage
        collectionView?.backgroundColor = UIColor.white
        //collectionView?.alwaysBounceVertical = true
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        //register cells & header
        collectionView?.register(ListCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(ListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
         
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.ingredientListCount()
    }
    
    //display list
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ListCell
        listCell.nameLabel.text = ingredients.getIngredientName(index:indexPath.item)
        listCell.amountLabel.text = String(ingredients.getIngredientAmount(index: indexPath.item))
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
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! ListHeader
        header.pantryViewController = self
        header.backgroundColor = UIColor.white
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //change lists
    func addNewIngredient(ingredientName: String){
        var ingredient = Ingredient(name: ingredientName, amount: 1)
        if(isShoppingList){
            shoppingList.addIngredient(ingredient: ingredient)
            ingredients.copy(other: shoppingList)
        }
        else{
            pantryList.addIngredient(ingredient: ingredient)
            ingredients.copy(other: pantryList)
        }
        collectionView?.reloadData()
    }
    
    func moveSelected(){
        //if we're currently looking at shopping list
        if(isShoppingList){
            for i in 0..<(shoppingList.ingredientListCount()){
                if shoppingList.getSelect(index: i){
                    //FIX THIS
                    var temp = Ingredient(name: shoppingList.getIngredientName(index: i), amount: 1)
                    pantryList.addIngredient(ingredient: temp)
                }
            }
            shoppingList.removeSelectedIngredients()
            ingredients.copy(other: shoppingList)
        }
        else{
            for i in 0..<(pantryList.ingredientListCount()){
                if pantryList.getSelect(index: i){
                    //FIX THIS
                    var temp = Ingredient(name: pantryList.getIngredientName(index: i), amount: 1)
                    shoppingList.addIngredient(ingredient: temp)
                }
            }
            pantryList.removeSelectedIngredients()
            ingredients.copy(other: pantryList)
        }

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
        collectionView?.reloadData()
    }
    
    func showShoppingList(){
        pantryList.copy(other: ingredients)
        ingredients.copy(other: shoppingList)
        isShoppingList = true
        collectionView?.reloadData()
    }
    
    func showPantryList(){
        shoppingList.copy(other: ingredients)
        ingredients.copy(other: pantryList)
        isShoppingList = false
        collectionView?.reloadData()
    }
    
    func showIngredientViewController(index: Int) {
        let ingredientVC = IngredientViewController(input: ingredients.getIngredient(index: index), pantry: self, index: index)
        present(ingredientVC, animated: true, completion: nil)
    }
    
}


class ListHeader: BaseCell {
    
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
        button.setTitle("Add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let shoppingListButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Shopping List", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let pantryListButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1
        button.setTitle("Pantry List", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let moveSelectedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Move", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    override func setupViews(){
        addSubview(title)
        addSubview(shoppingListButton)
        addSubview(pantryListButton)
        addSubview(ingredientNameTextField)
        addSubview(addIngredientButton)
        addSubview(moveSelectedButton)
        
        shoppingListButton.addTarget(self, action: #selector(ListHeader.showShoppingList(_:)), for: .touchUpInside)
        pantryListButton.addTarget(self, action: #selector(ListHeader.showPantryList(_:)), for: .touchUpInside)
        addIngredientButton.addTarget(self, action: #selector(ListHeader.addIngredient(_:)), for: .touchUpInside)
        moveSelectedButton.addTarget(self, action: #selector(ListHeader.moveSelected(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-[v2]-[v1(80)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField, "v1":addIngredientButton, "v2":moveSelectedButton ]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0(150)]-[v1(150)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":shoppingListButton, "v1":pantryListButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-60-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":title]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-110-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":title]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-85-[v0(50)]-20-[v1]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":pantryListButton, "v1":ingredientNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-85-[v0(50)]-20-[v1]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":shoppingListButton, "v1":addIngredientButton]))
    }
    
    @objc func addIngredient(_ sender:UIButton!){
        pantryViewController?.addNewIngredient(ingredientName: ingredientNameTextField.text!)
        ingredientNameTextField.text = ""
    }
    
    @objc func showShoppingList(_ sender:UIButton!){
        shoppingListButton.layer.borderColor = UIColor.black.cgColor
        pantryListButton.layer.borderColor = UIColor.white.cgColor
        pantryViewController?.showShoppingList()
    }
    
    @objc func showPantryList(_ sender:UIButton!){
        pantryListButton.layer.borderColor = UIColor.black.cgColor
        shoppingListButton.layer.borderColor = UIColor.white.cgColor
        pantryViewController?.showPantryList()
    }
    
    @objc func moveSelected(_ sender:UIButton!){
        pantryViewController?.moveSelected()
    }
}


class ListCell: BaseCell {
    
    var pantryViewController: PantryViewController?
    
    var listIndex: Int = 0

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Ingredient"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "amount"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let removeIngredientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    let selectIngredientButton: UIButton = {
        let button = UIButton(type: .system)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .selected)
        button.setTitleShadowColor(UIColor.clear, for: .normal)
        button.setTitleShadowColor(UIColor.clear, for: .selected)
        button.isSelected = false
        button.showsTouchWhenHighlighted = false
        return button
    } ()
    
    override func setupViews(){
        addSubview(nameLabel)
        addSubview(amountLabel)
        addSubview(removeIngredientButton)
        addSubview(selectIngredientButton)
        
        removeIngredientButton.addTarget(self, action: #selector(ListCell.removeIngredient(_:)), for: .touchUpInside)
        selectIngredientButton.addTarget(self, action: #selector(ListCell.selectIngredient(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v2(30)]-[v3]-[v0]-[v1(80)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":removeIngredientButton, "v2":selectIngredientButton, "v3": amountLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":removeIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":selectIngredientButton]))
    }
    
    @objc func removeIngredient(_ sender:UIButton!){
        //pantryViewController?.removeIngredient(index: listIndex)
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


class IngredientList {
    var ingredientList: [Ingredient] = []
    var selectedList: [Bool] = []
    
    func decreaseIngredientAmount(index:Int){
        ingredientList[index].amount -= 1
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

