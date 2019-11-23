//
//  RecipeSearchViewController.swift
//  Frydge
//

import UIKit

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var isShoppingList = true;
    var ingredients = IngredientList()
    var shoppingList = IngredientList()
    var pantryList = IngredientList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.text = "Ingredients"
            label.font = UIFont(name: "Comfortaa", size: 42)
            label.textColor = .black
            return label
        }()
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32.0).isActive = true
        header.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64.0).isActive = true
    
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
        collectionView?.alwaysBounceVertical = true
        
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
        listCell.nameLabel.text = ingredients.getIngredient(index:indexPath.item)
        listCell.pantryViewController = self
        return listCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    //display header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! ListHeader
        header.pantryViewController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //change lists
    func addNewIngredient(ingredientName: String){
        let ingredient = Ingredient(name: ingredientName, amount: 1)
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
    
    func removeIngredient(ingredientName: String){
        if(isShoppingList){
            print("is shopping list")
            //shoppingList.removeAll { $0 == ingredientName }
            //ingredients = shoppingList
        }
        else{
            print("is pantry list")
            //pantryList.removeAll { $0 == ingredientName }
            //ingredients = pantryList
        }
        collectionView?.reloadData()
    }
    
    func showShoppingList(){
        ingredients.copy(other: shoppingList)
        isShoppingList = true
        collectionView?.reloadData()
    }
    
    func showPantryList(){
        ingredients.copy(other: pantryList)
        isShoppingList = false
        collectionView?.reloadData()
    }
    /*
    func getPantryList(inputArray:Array<String>) -> Array<String> {
        return pantryList
    }
    func getShoppingList(inputArray:Array<String>) -> Array<String> {
        return shoppingList
    }
 */
    
}


class ListHeader: BaseCell {
    
    var pantryViewController: PantryViewController?

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
    
    override func setupViews(){
        addSubview(shoppingListButton)
        addSubview(pantryListButton)
        addSubview(ingredientNameTextField)
        addSubview(addIngredientButton)
        
        shoppingListButton.addTarget(self, action: #selector(ListHeader.showShoppingList(_:)), for: .touchUpInside)
        pantryListButton.addTarget(self, action: #selector(ListHeader.showPantryList(_:)), for: .touchUpInside)
        addIngredientButton.addTarget(self, action: #selector(ListHeader.addIngredient(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-[v1(80)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField, "v1":addIngredientButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0(150)]-[v1(150)]-40-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":shoppingListButton, "v1":pantryListButton]))
        
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
}


class ListCell: BaseCell {
    
    var pantryViewController: PantryViewController?
    private var isToggledOn: Bool = false

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Ingredient"
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
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    
    override func setupViews(){
        addSubview(nameLabel)
        addSubview(removeIngredientButton)
        addSubview(selectIngredientButton)
        
        removeIngredientButton.addTarget(self, action: #selector(ListCell.removeIngredient(_:)), for: .touchUpInside)
        selectIngredientButton.addTarget(self, action: #selector(ListCell.selectIngredient(_:)), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v2(30)]-[v0]-[v1(80)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":removeIngredientButton, "v2":selectIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":removeIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v0]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":selectIngredientButton]))
    }
    
    @objc func removeIngredient(_ sender:UIButton!){
        pantryViewController?.removeIngredient(ingredientName: nameLabel.text!)
    }
    @objc func selectIngredient(_ sender:UIButton!){
        if(!isToggledOn){
            isToggledOn = true
            selectIngredientButton.backgroundColor = UIColor.blue
        }
        else{
            isToggledOn = false
            selectIngredientButton.backgroundColor = UIColor.clear
        }
        //pantryViewController?.selectIngredient(ingredientName: nameLabel.text!)
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
    
    //CHANGE TO INGREDIENT RETURN TYPE
    func getIngredient(index: Int) -> String{
        return ingredientList[index].name
    }
    
    func getSelect(index: Int) -> Bool{
        return selectedList[index]
    }
    
    func addIngredient(ingredient: Ingredient){
        ingredientList.append(ingredient)
        selectedList.append(false)
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

