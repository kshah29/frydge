//
//  RecipeSearchViewController.swift
//  Frydge
//
//  Created by Natasha Sarkar on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit


class RecipeSearchViewController: UIViewController, UISearchBarDelegate {
    
    let searchbarBackgroundView = UIView(frame: .zero)
    let searchbar = UISearchBar(frame: CGRect(x: 10, y: 50, width: 390.0, height: 50.0))
    var recipes: [Recipe]? = nil
    var recipeViews: [UIView] = []
    var compiledRecipes: Bool = false
    var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
    
    let dimmerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.35)
        view.isHidden = true
        return view
    }()
    var searchOptionsView: SearchOptionsView? {
        didSet {
            guard let searchOptionsView = searchOptionsView else { return }
            searchOptionsViewPositions = [
                "hidden": NSLayoutConstraint(item: searchOptionsView, attribute: .bottom, relatedBy: .equal, toItem: searchbar, attribute: .bottom, multiplier: 1, constant: 0),
                "shown": NSLayoutConstraint(item: searchOptionsView, attribute: .top, relatedBy: .equal, toItem: searchbar, attribute: .bottom, multiplier: 1, constant: 0)
            ]
        }
    }
    
    var searchOptionsViewPositions: [String : NSLayoutConstraint]?
    
    public func getRecipes(query: String) {
        self.recipes = []
        self.compiledRecipes = false
        makeRequest(ingredientList: query.components(separatedBy: " "))
        while (self.compiledRecipes == false){
            // DO nothing - wait for it to populate
        }
        populateRecipes()
    }
    
    
    @objc func showRecipeViewController(_ sender: UITapGestureRecognizer) {
        for recipe in self.recipes! {
            if sender.view?.tag == recipe.id {
                let recipeVC = RecipeViewController(forRecipe: recipe)
                present(recipeVC, animated: true, completion: nil)
            }
        }
    }
    
    func dummyMakeRequest() {
        let ingredients = [Ingredient(name: "some kind of dough", amount: 1), Ingredient(name: "roasted red grapes", amount: 1), Ingredient(name: "double cream Brie", amount: 1), Ingredient(name: "caramelized onions", amount: 1), Ingredient(name: "Parmesan", amount: 1), Ingredient(name: "fresh wild arugula", amount: 1)]
        let process = """
            1. Prepare dough.
            2. Assemble ingredients.
            3. Cook.
            4. Plate.
            """
        
        let ingredients2: [Ingredient] = []
        let process2 = ""

        var recipes = [
            Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process,
                   image: "https://assets.kraftfoods.com/recipe_images/opendeploy/193146_640x428.jpg"),
            Recipe(id: 1, title: "Untitled Thing 2", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg")
        ]
        
        for i in 2...10 {
            recipes.append(
                Recipe(id: i, title: "Another Thing", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg")
            )
        }
            
        self.recipes = recipes
    }

    private func parseRecipeJSON (recipeJSON : [String: Any]){
        let results = recipeJSON["results"] as? [Any]
        
        for element in results ?? [] {
            
            if let element = element as? [String:Any] {
                let title = element["title"]
                print("TITLE")
                print(title)
                
                let nid = element["id"] as? Int
                print(nid)
                
                let prepTime = element["preparationMinutes"]
                print(prepTime)
                let cookTime = element["cookingMinutes"]
                print(cookTime)
                
                let imageURL = element["image"]
                print(imageURL)
                
                let instruction = element["analyzedInstructions"] as? [Any]
                let procedure = instruction?[0] as? [String:Any]
                
                let steps = procedure?["steps"] as? [Any] ?? []
                var num : Int = 1
                var process : String = ""
                for eachStep in steps{
                    if let eachStep = eachStep as? [String:Any]{
                        let step = eachStep["step"] as? String
                        let pre = String(num) + ". "
                        let end = step! + "\n"
                        process = process + pre + end
                    }
                    num = num + 1
                }
                print(process)
                
                self.recipes?.append(Recipe(id: nid ?? 0, title: title as! String, ingredientList: [], process: process, image: imageURL as! String))
            }
        }
        
        compiledRecipes = true
    }
    
    private func makeRequest (ingredientList : [String]) -> Void {
        let foodAPIURL = "https://api.spoonacular.com/recipes/complexSearch"
        let apiKey : String = "b8bc0943e3784d28ae91cbe52ed432c9"
        var ingredientString : String = ""
        
        for ingredient in ingredientList {
            if ingredientString == ""{
                ingredientString = ingredient
            } else {
                ingredientString = ingredientString + ",+" + ingredient
            }
        }
        
        let diet = PersonalData.getDietaryRestrictions()
        var dietParam = ""
        if (diet != ""){
            dietParam = "&diet=" + diet
        }
        
        let intolerance = PersonalData.getIntoleranceString()
        var intoleranceParam = ""
        if (intolerance != ""){
            intoleranceParam += "&intolerances" + intolerance
        }
        
        let queryNumber = "10"
        
        let procedureParam = "&instructionsRequired=true"
        let recipeInfo = "&addRecipeInformation=true"
        
        let urlWithParams = foodAPIURL + "?apiKey=" + apiKey  + dietParam + intoleranceParam + "&includeIngredients=" + ingredientString + procedureParam + recipeInfo + "&number=" + queryNumber
        print(urlWithParams)
        
        
        // Excute HTTP Request
        let url = URL(string: urlWithParams)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {

                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]

                        self.parseRecipeJSON(recipeJSON: parsedData)
                        
                    } catch let error as NSError {
                              print("Error Parsing Json \(error)" )
                    }
                }
            }
        }
        task.resume()
    }
    
    func populateRecipes() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
//        super.viewDidLoad()
        
        let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .white
            v.addSubview(backgroundImage)
            return v
        }()
        
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        
        view.addSubview(dimmerView)
        searchOptionsView = SearchOptionsView(frame: .zero)
        guard let searchOptionsView = searchOptionsView else { return }
        view.addSubview(searchOptionsView)
        
        searchbarBackgroundView.backgroundColor = .white
        searchbarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        view.addSubview(searchbarBackgroundView)
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        NSLayoutConstraint.activate([
            searchOptionsView.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchOptionsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchOptionsView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        searchOptionsViewPositions?["hidden"]?.isActive = true
        
        
        var list = [
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        if self.recipes != nil {
            self.recipeViews = []
            for recipe in self.recipes! {
                guard let recipeView = recipe.recipePreview() else { return }
                recipeViews.append(recipeView)
            }
        }
        var i = 0
        for recipeView in recipeViews {
            
            // add the recipe to the view
            scrollView.addSubview(recipeView)
            let top = (220 * i)
            list.append(recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            // add the favorite button to the view, tagged with the recipe's id
            let current_recipe = (self.recipes)![i]
            let y_coord = (220 * i) + 10
            
            recipeView.tag = current_recipe.id
            let tapRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(self.showRecipeViewController(_:)))
            recipeView.addGestureRecognizer(tapRecipeGesture)
            
            let scrollContentHeight = CGFloat(220 * recipeViews.count)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollContentHeight)
            
            i = i + 1
        }
    
        NSLayoutConstraint.activate(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.populateRecipes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchbar.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        if searchbar.text != nil {
            getRecipes(query: searchbar.text!)
        }
        else{
            getRecipes(query: "")
        }
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            getRecipes(query: searchBar.text!)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchOptionsViewPositions?["hidden"]?.isActive = false
        searchOptionsViewPositions?["shown"]?.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.dimmerView.isHidden = false
            self.dimmerView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchOptionsViewPositions?["shown"]?.isActive = false
        searchOptionsViewPositions?["hidden"]?.isActive = true
        
        UIView.animate(withDuration: 0.2) {
            self.dimmerView.isHidden = true
            self.dimmerView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}



//MARK:- Search Options View
class SearchOptionsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let collectionView = collectionView as? SearchOptionsCollectionView {
            if collectionView.selectionType == .dietaryRestrictions {
                return 3
            }
            else if collectionView.selectionType == .allergies {
                return 7
            }
            else {
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchOptionCell", for: indexPath)
        if let cell = cell as? SearchOption, let collectionView = collectionView as? SearchOptionsCollectionView {
            cell.delegate = collectionView
            if collectionView.selectionType == .dietaryRestrictions {
                cell.selectionType = .dietaryRestrictions
                switch indexPath.row {
                case 0:
                    cell.optionName.text = "VEGETARIAN"
                    cell.optionIsSelected = PersonalData.getVegetarian()
                case 1:
                    cell.optionName.text = "VEGAN"
                    cell.optionIsSelected = PersonalData.getVegan()
                default:
                    cell.optionName.text = "PALEO"
                    cell.optionIsSelected = PersonalData.getPaleo()
                }
            }
            else if collectionView.selectionType == .allergies {
                cell.selectionType = .allergies
                switch indexPath.row {
                case 0:
                    cell.optionName.text = "DAIRY"
                    cell.optionIsSelected = PersonalData.getDairy()
                case 1:
                    cell.optionName.text = "EGG"
                    cell.optionIsSelected = PersonalData.getEggFree()
                case 2:
                    cell.optionName.text = "GLUTEN"
                    cell.optionIsSelected = PersonalData.getGlutenFree()
                case 3:
                    cell.optionName.text = "PEANUT"
                    cell.optionIsSelected = PersonalData.getPeanutFree()
                case 4:
                    cell.optionName.text = "WHEAT"
                    cell.optionIsSelected = PersonalData.getWheatFree()
                case 5:
                    cell.optionName.text = "SHELLFISH"
                    cell.optionIsSelected = PersonalData.getfishFree()
                default:
                    cell.optionName.text = "SUGAR"
                    cell.optionIsSelected = PersonalData.getLowSugar()
                }
            }
            else {
                
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 10, height: 40)
    }
    
    lazy var restrictionsListHeights = [
        "hidden": NSLayoutConstraint(item: restrictionsList, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0),
        "shown": NSLayoutConstraint(item: restrictionsList, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
    ]
    let restrictionsDropdownHeader = DropdownHeaderView(title: "Dietary Restrictions")
    let restrictionsList = SearchOptionsCollectionView(selectionType: .dietaryRestrictions)
    
    lazy var allergiesListHeights = [
        "hidden": NSLayoutConstraint(item: allergiesList, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0),
        "shown": NSLayoutConstraint(item: allergiesList, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
    ]
    let allergiesDropdownHeader = DropdownHeaderView(title: "Allergies")
    let allergiesList = SearchOptionsCollectionView(selectionType: .allergies)
    
    let dividerView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(restrictionsDropdownHeader)
        let showRestrictionsGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleRestrictionsDropdown(_:)))
        restrictionsDropdownHeader.addGestureRecognizer(showRestrictionsGesture)
        addSubview(restrictionsList)
        
        addSubview(allergiesDropdownHeader)
        let showAllergiesGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleAllergiesDropdown(_:)))
        allergiesDropdownHeader.addGestureRecognizer(showAllergiesGesture)
        addSubview(allergiesList)
        
        addSubview(dividerView1)
        
        NSLayoutConstraint.activate([
            restrictionsDropdownHeader.topAnchor.constraint(equalTo: topAnchor),
            restrictionsDropdownHeader.leftAnchor.constraint(equalTo: leftAnchor),
            restrictionsDropdownHeader.rightAnchor.constraint(equalTo: rightAnchor),
            restrictionsDropdownHeader.heightAnchor.constraint(equalToConstant: 40),
            
            restrictionsList.topAnchor.constraint(equalTo: restrictionsDropdownHeader.bottomAnchor),
            restrictionsList.leftAnchor.constraint(equalTo: leftAnchor),
            restrictionsList.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        restrictionsListHeights["hidden"]?.isActive = true
        
        NSLayoutConstraint.activate([
            dividerView1.topAnchor.constraint(equalTo: restrictionsList.bottomAnchor),
            dividerView1.leftAnchor.constraint(equalTo: leftAnchor),
            dividerView1.rightAnchor.constraint(equalTo: rightAnchor),
            dividerView1.heightAnchor.constraint(equalToConstant: 2),
            
            allergiesDropdownHeader.topAnchor.constraint(equalTo: dividerView1.bottomAnchor),
            allergiesDropdownHeader.leftAnchor.constraint(equalTo: leftAnchor),
            allergiesDropdownHeader.rightAnchor.constraint(equalTo: rightAnchor),
            allergiesDropdownHeader.heightAnchor.constraint(equalToConstant: 40),
            
            allergiesList.topAnchor.constraint(equalTo: allergiesDropdownHeader.bottomAnchor),
            allergiesList.leftAnchor.constraint(equalTo: leftAnchor),
            allergiesList.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        allergiesListHeights["hidden"]?.isActive = true
        
        restrictionsList.register(SearchOption.self, forCellWithReuseIdentifier: "SearchOptionCell")
        restrictionsList.dataSource = self
        restrictionsList.delegate = self
        
        allergiesList.register(SearchOption.self, forCellWithReuseIdentifier: "SearchOptionCell")
        allergiesList.dataSource = self
        allergiesList.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class DropdownHeaderView: UIView {
        init(title: String) {
            super.init(frame: .zero)
            
            backgroundColor = .white
            translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.font = UIFont(name: "Comfortaa", size: 24)
            label.text = title
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let dropdownArrow = UIImageView(image: #imageLiteral(resourceName: "arrow"))
            dropdownArrow.translatesAutoresizingMaskIntoConstraints = false
            dropdownArrow.contentMode = .scaleAspectFit
            dropdownArrow.tintColor = #colorLiteral(red: 0.5136051178, green: 0.5133855939, blue: 0.5340548754, alpha: 1)
            
            addSubview(label)
            addSubview(dropdownArrow)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                label.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                dropdownArrow.topAnchor.constraint(equalTo: topAnchor),
                dropdownArrow.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                dropdownArrow.widthAnchor.constraint(equalToConstant: 20),
                dropdownArrow.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    @objc func toggleRestrictionsDropdown(_ sender: UITapGestureRecognizer) {
        if let hidden = restrictionsListHeights["hidden"], let shown = restrictionsListHeights["shown"] {
            hidden.isActive = !hidden.isActive
            shown.isActive = !shown.isActive
        
            UIView.animate(withDuration: 0.2) {
                if hidden.isActive {
                    self.restrictionsDropdownHeader.subviews[1].transform = CGAffineTransform.identity
                }
                else {
                    self.restrictionsDropdownHeader.subviews[1].transform = CGAffineTransform(rotationAngle: .pi)
                }
                self.layoutIfNeeded()
            }
        }
    }
    @objc func toggleAllergiesDropdown(_ sender: UITapGestureRecognizer) {
        if let hidden = allergiesListHeights["hidden"], let shown = allergiesListHeights["shown"] {
            hidden.isActive = !hidden.isActive
            shown.isActive = !shown.isActive
        
            UIView.animate(withDuration: 0.2) {
                if hidden.isActive {
                    self.allergiesDropdownHeader.subviews[1].transform = CGAffineTransform.identity
                }
                else {
                    self.allergiesDropdownHeader.subviews[1].transform = CGAffineTransform(rotationAngle: .pi)
                }
                self.layoutIfNeeded()
            }
        }
    }
}

enum SearchOptionType {
    case dietaryRestrictions
    case allergies
    case ingredients
}
class SearchOptionsCollectionView: UICollectionView, SearchOptionDelegate {
    var selectionType: SearchOptionType
    func toggleOption(index: IndexPath) {
        if let sender = cellForItem(at: index) as? SearchOption {
            if sender.selectionType == .dietaryRestrictions {
                for cell in visibleCells {
                    if let cell = cell as? SearchOption, cell != sender {
                        cell.optionIsSelected = false
                    }
                }
            }
        }
    }
    
    init(selectionType type: SearchOptionType) {
        selectionType = type
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.9198423028, green: 0.9198423028, blue: 0.9198423028, alpha: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchOption: BaseCell {
    var delegate: SearchOptionDelegate?
    var selectionType: SearchOptionType?
    var optionIsSelected: Bool? {
        didSet {
            guard let optionIsSelected = optionIsSelected else { return }
            if (optionIsSelected) {
                selectionButton.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            else {
                selectionButton.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    var selectionButton: UIButton = {
       let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    var optionName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(selectionButton)
        contentView.addSubview(optionName)
        NSLayoutConstraint.activate([
            selectionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            selectionButton.heightAnchor.constraint(equalToConstant: 24),
            selectionButton.widthAnchor.constraint(equalToConstant: 24),
            
            optionName.topAnchor.constraint(equalTo: contentView.topAnchor),
            optionName.leftAnchor.constraint(equalTo: selectionButton.rightAnchor, constant: 10),
            optionName.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            optionName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        selectionButton.addTarget(self, action: #selector(SearchOption.toggleSelected(_:)), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleSelected(_ sender: Any) {
        optionIsSelected = !(optionIsSelected ?? false)
        if let collectionView = superview as? UICollectionView, let index = collectionView.indexPath(for: self) {
            delegate?.toggleOption(index: index)
        }
    }
}

protocol SearchOptionDelegate {
    func toggleOption(index: IndexPath)
}
