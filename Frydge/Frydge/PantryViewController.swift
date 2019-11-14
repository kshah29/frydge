//
//  RecipeSearchViewController.swift
//  Frydge
//

import UIKit

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
    
    var ingredients: [String] = []
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    //show all cells
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ListCell
        listCell.nameLabel.text = ingredients[indexPath.item]
        listCell.pantryViewController = self
        return listCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! ListHeader
        header.pantryViewController = self
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func addNewIngredient(ingredientName: String){
        ingredients.append(ingredientName)
        collectionView?.reloadData()
    }
    
    func removeIngredient(ingredientName: String){
        ingredients.removeAll { $0 == ingredientName }
        collectionView?.reloadData()
    }
    
    func getIngredients(inputArray:Array<String>) -> Array<String> {
        return ingredients
    }
    
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
    
    override func setupViews(){
        addSubview(ingredientNameTextField)
        addSubview(addIngredientButton)
        
        addIngredientButton.addTarget(self, action: #selector(ListHeader.addIngredient(_:)), for: .touchUpInside)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField, "v1":addIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":addIngredientButton]))
    }
    
    @objc func addIngredient(_ sender:UIButton!){
        pantryViewController?.addNewIngredient(ingredientName: ingredientNameTextField.text!)
        ingredientNameTextField.text = ""
    }
}


class ListCell: BaseCell {
    
    var pantryViewController: PantryViewController?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Ingredient"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let addRemoveIngredientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    
    override func setupViews(){
        addSubview(nameLabel)
        addSubview(addRemoveIngredientButton)
        
        addRemoveIngredientButton.addTarget(self, action: #selector(ListCell.removeIngredient(_:)), for: .touchUpInside)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-[v1(80)]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel, "v1":addRemoveIngredientButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":addRemoveIngredientButton]))
    }
    
    @objc func removeIngredient(_ sender:UIButton!){
        pantryViewController?.removeIngredient(ingredientName: nameLabel.text!)
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
