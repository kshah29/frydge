//
//  RecipeSearchViewController.swift
//  Frydge
//

import UIKit

class PantryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

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
        collectionView?.alwaysBounceVertical = true
        
        //register cells & header
        collectionView?.register(ListCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.register(ListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
         
    }
    
    var ingredients: [String] = []
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ListCell
        listCell.nameLabel.text = ingredients[indexPath.item]
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
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func addNewIngredient(ingredientName: String){
        ingredients.append(ingredientName)
        collectionView?.reloadData()
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
        button.setTitle("Add Ingredient", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    override func setupViews(){
        addSubview(ingredientNameTextField)
        addSubview(addIngredientButton)
        
        addIngredientButton.addTarget(self, action: #selector(ListHeader.addIngredient(_:)), for: .touchUpInside)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField, "v1":addIngredientButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[v0]-24-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":ingredientNameTextField]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":addIngredientButton]))
    }
    
    @objc func addIngredient(_ sender:UIButton!){
        pantryViewController?.addNewIngredient(ingredientName: ingredientNameTextField.text!)
        ingredientNameTextField.text = ""
    }
}


class ListCell: BaseCell {

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Ingredient"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override func setupViews(){
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0":nameLabel]))
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
