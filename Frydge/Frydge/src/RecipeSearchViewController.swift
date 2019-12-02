//
//  RecipeSearchViewController.swift
//  Frydge
//
//  Created by Natasha Sarkar on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class RecipeSearchViewController: UIViewController, UISearchBarDelegate, SearchOptionsViewDelegate {
    func updateSearchOptions(newRestrictionsString: String?, newIntolerancesString: String?) {
        restrictionsString = newRestrictionsString ?? restrictionsString
        intolerancesString = newIntolerancesString ?? intolerancesString
    }
    
    
    let searchbarBackgroundView = UIView(frame: .zero)
    let searchbar = UISearchBar(frame: CGRect(x: 10, y: 50, width: 390.0, height: 50.0))
    var recipes: [Recipe]? = nil
    var recipeViews: [UIView] = []
    var compiledRecipes: Bool = false
    var backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble"))
    var offset = 0;
    var query = "";
    var restrictionsString = PersonalData.getDietaryRestrictions()
    var intolerancesString = PersonalData.getIntoleranceString()
    
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
    

    @objc public func getRecipes() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        self.recipes = []
        self.compiledRecipes = false
        makeRequest(ingredientList: self.query.components(separatedBy: " "))
        while (self.compiledRecipes == false){
            // DO nothing - wait for it to populate
        }
        populateRecipes();
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
        let process = [
            "Prepare dough.",
            "Assemble ingredients.",
            "Cook.",
            "Plate."
        ]
        
        let ingredients2: [Ingredient] = []
        let process2: [String] = []

        var recipes = [
            Recipe(id: 0, title: "Grilled Chicken Sonoma Flatbread", ingredientList: ingredients, process: process,
                   image: "https://assets.kraftfoods.com/recipe_images/opendeploy/193146_640x428.jpg", prepTime: nil, cookTime: nil),
            Recipe(id: 1, title: "Untitled Thing 2", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg", prepTime: nil, cookTime: nil)
        ]
        
        for i in 2...10 {
            recipes.append(
                Recipe(id: i, title: "Another Thing", ingredientList: ingredients2, process: process2,
                   image: "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg", prepTime: nil, cookTime: nil)
            )
        }
            
        self.recipes = recipes
    }

    public func parseRecipeJSON (recipeJSON : [String: Any]){
        let results = recipeJSON["results"] as? [Any]
        
        for element in results ?? [] {
            
            if let element = element as? [String:Any] {
                let title = element["title"]
                print("TITLE")
                print(title)
                
                let nid = element["id"] as? Int
                print(nid)
                
                let prepTime: Int? = element["preparationMinutes"] as? Int
                print(prepTime)
                let cookTime: Int? = element["cookingMinutes"] as? Int
                print(cookTime)
                
                let imageURL = element["image"]
                print(imageURL)
                
                let instruction = element["analyzedInstructions"] as? [Any]
                var process: [String] = []
                if instruction?.count ?? 0 > 0 {
                    let procedure = instruction?[0] as? [String:Any]
                    
                    let steps = procedure?["steps"] as? [Any] ?? []
                    for eachStep in steps{
                        if let eachStep = eachStep as? [String:Any]{
                            let step = eachStep["step"] as? String
                            if let step = step { process.append(step) }
                        }
                    }
                    print(process)
                }
                
                let newRecipe = Recipe(id: nid ?? 0, title: title as! String, ingredientList: [], process: process, image: imageURL as! String, prepTime: prepTime, cookTime: cookTime)
                for recipe in RecipeStore.getRecipeList() {
                    if newRecipe.id == recipe.id {
                        newRecipe.isFavorited = true
                    }
                }
                self.recipes?.append(newRecipe)
            }
        }
        
        compiledRecipes = true
    }
    
    public func makeRequest (ingredientList : [String]) -> Void {
        let foodAPIURL = "https://api.spoonacular.com/recipes/complexSearch"
        let apiKey : String = "78eaab53fe1f4270932a90b65f805c64"
        var ingredientString : String = ""
        
        for ingredient in ingredientList {
            if ingredientString == ""{
                ingredientString = ingredient
            } else {
                ingredientString = ingredientString + ",+" + ingredient
            }
        }
        
//        let diet = PersonalData.getDietaryRestrictions()
        let diet = restrictionsString
        var dietParam = ""
        if (diet != ""){
            dietParam = "&diet=" + diet
        }
        
//        let intolerance = PersonalData.getIntoleranceString()
        let intolerance = intolerancesString
        var intoleranceParam = ""
        if (intolerance != ""){
            intoleranceParam += "&intolerances" + intolerance
        }
        
        let queryNumber = "10"
        
        let procedureParam = "&instructionsRequired=true"
        let recipeInfo = "&addRecipeInformation=true"
        
        let urlWithParams = foodAPIURL + "?apiKey=" + apiKey  + dietParam + intoleranceParam + "&includeIngredients=" + ingredientString + procedureParam + recipeInfo + "&number=" + queryNumber + "&offset=" + String(self.offset)
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
        self.offset = self.offset + 10;
    }
    
    func populateRecipes() {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
//        super.viewDidLoad()
        
        searchbar.barTintColor = UIColor(named: "blue")
        searchbar.delegate = self
//        view.addSubview(searchbar)
        
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
        restrictionsString = PersonalData.getDietaryRestrictions()
        intolerancesString = PersonalData.getIntoleranceString()
        searchOptionsView = SearchOptionsView(frame: .zero)
        searchOptionsView?.searchOptionsCVDelegate = self
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
            let top = (220 * i + 20)
            list.append(recipeView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: CGFloat(top)))
            list.append(recipeView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor))
            list.append(recipeView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9))
            list.append(recipeView.heightAnchor.constraint(equalToConstant: 200))
            
            // add the favorite button to the view, tagged with the recipe's id
            let current_recipe = (self.recipes)![i]
            
            recipeView.tag = current_recipe.id
            let tapRecipeGesture = UITapGestureRecognizer(target: self, action: #selector(self.showRecipeViewController(_:)))
            recipeView.addGestureRecognizer(tapRecipeGesture)
            
            let scrollContentHeight = CGFloat(220 * recipeViews.count + 70)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollContentHeight)
            
            i = i + 1
        }
        
        let load_more_button = UIButton(frame: CGRect(x: 20, y: 2220, width: 200, height: 30))
        load_more_button.backgroundColor = UIColor(red: 166/256, green: 165/256, blue: 162/256, alpha: 0.5)
        
        load_more_button.setTitle("...load more recipes", for: .normal)
        load_more_button.addTarget(self, action: #selector(getRecipes), for: .touchUpInside)
        
        scrollView.addSubview(load_more_button)
        NSLayoutConstraint.activate(list)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restrictionsString = PersonalData.getDietaryRestrictions()
        intolerancesString = PersonalData.getIntoleranceString()
        
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
            self.query = searchbar.text!
            getRecipes()
        }
        else{
            getRecipes()
        }
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in view.subviews {
            if let scroll = view as? UIScrollView {
                scroll.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.offset = 0
        searchBar.resignFirstResponder()
        if searchBar.text != nil {
            self.query = searchBar.text!
            getRecipes()
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
class SearchOptionsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchOptionsCollectionViewDelegate {
    var searchOptionsCVDelegate: SearchOptionsViewDelegate?
    func updateSearchOptions(newRestrictionsString: String?, newIntolerancesString: String?) {
        searchOptionsCVDelegate?.updateSearchOptions(newRestrictionsString: newRestrictionsString, newIntolerancesString: newIntolerancesString)
    }
    
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
        restrictionsList.searchOptionsCollectionViewDelegate = self
        addSubview(restrictionsList)
        
        addSubview(allergiesDropdownHeader)
        let showAllergiesGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleAllergiesDropdown(_:)))
        allergiesDropdownHeader.addGestureRecognizer(showAllergiesGesture)
        allergiesList.searchOptionsCollectionViewDelegate = self
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
    var searchOptionsCollectionViewDelegate: SearchOptionsCollectionViewDelegate?
    var selectionType: SearchOptionType
    func toggleOption(index: IndexPath) {
        if let sender = cellForItem(at: index) as? SearchOption {
            if sender.selectionType == .dietaryRestrictions {
                for cell in visibleCells {
                    if let cell = cell as? SearchOption, cell != sender {
                        cell.optionIsSelected = false
                    }
                    else if let cell = cell as? SearchOption, cell == sender {
                        var newRString = ""
                        switch cell.optionName.text {
                        case "VEGETARIAN": newRString = "Vegetarian"
                        case "VEGAN": newRString = "Vegan"
                        default: newRString = "Paleo"
                        }
                        searchOptionsCollectionViewDelegate?.updateSearchOptions(newRestrictionsString: newRString, newIntolerancesString: nil)
                    }
                }
            }
            else {
                var intolerancesChosen: [String:Bool] = [:]
                for cell in visibleCells {
                    if let cell = cell as? SearchOption {
                        switch cell.optionName.text {
                        case "DAIRY": intolerancesChosen["Dairy"] = cell.optionIsSelected
                        case "EGG": intolerancesChosen["Egg"] = cell.optionIsSelected
                        case "GLUTEN": intolerancesChosen["Gluten"] = cell.optionIsSelected
                        case "PEANUT": intolerancesChosen["Peanut"] = cell.optionIsSelected
                        case "WHEAT": intolerancesChosen["Wheat"] = cell.optionIsSelected
                        case "SHELLFISH": intolerancesChosen["Shellfish"] = cell.optionIsSelected
                        default: intolerancesChosen["Sugar"] = cell.optionIsSelected
                        }
                    }
                }
                var string = ""
                if (intolerancesChosen["Dairy"] ?? false) { string = "Dairy" }
                if (intolerancesChosen["Gluten"] ?? false) {
                    if string == "" {
                        string = "Gluten"
                    }
                    else {
                        string += ",Gluten"
                    }
                }
                if (intolerancesChosen["Wheat"] ?? false) {
                    if string == "" {
                        string = "Wheat"
                    }
                    else {
                        string += ",Wheat"
                    }
                }
                if (intolerancesChosen["Sugar"] ?? false) {
                    if string == "" {
                        string = "Sugar"
                    }
                    else {
                        string += ",Sugar"
                    }
                }
                if (intolerancesChosen["Egg"] ?? false) {
                    if string == "" {
                        string = "Egg"
                    }
                    else {
                        string += ",Egg"
                    }
                }
                if (intolerancesChosen["Peanut"] ?? false) {
                    if string == "" {
                        string = "Peanut"
                    }
                    else {
                        string += ",Peanut"
                    }
                }
                if (intolerancesChosen["Shellfish"] ?? false) {
                    if string == "" {
                        string = "Shellfish"
                    }
                    else {
                        string += ",Shellfish"
                    }
                }
                searchOptionsCollectionViewDelegate?.updateSearchOptions(newRestrictionsString: nil, newIntolerancesString: string)
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
protocol SearchOptionsCollectionViewDelegate {
    func updateSearchOptions(newRestrictionsString: String?, newIntolerancesString: String?)
}
protocol SearchOptionsViewDelegate {
    func updateSearchOptions(newRestrictionsString: String?, newIntolerancesString: String?)
}
