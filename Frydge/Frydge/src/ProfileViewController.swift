//
//  ProfileViewController.swift
//  Frydge
//
//  Created by David Lee on 11/14/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    let line: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.alpha = 0.5
        return iv
    }()
    
    // MARK: - Picture, Name, Membership
    lazy var headerContainerView: UIView = {
        let view = UIView()
        
        view.addSubview(profileImageView)
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.anchor(top: view.topAnchor, paddingTop: 88, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        
        view.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImageView.bottomAnchor, paddingTop: 30)
        
        view.addSubview(membershipLabel)
        membershipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        membershipLabel.anchor(top: nameLabel.bottomAnchor, paddingTop: 15)
        
        return view
    }()
    
    // Profile Image
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "avatar2")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    // Name
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "User"
        label.font = UIFont(name: "Comfortaa", size: 32)
        label.textColor = .black
        return label
    }()
    
    // Membership
    
    let membershipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "member since Nov. 2019"
        label.font = UIFont(name: "Comfortaa", size: 16)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Dietary Restrictions
    lazy var dietContainerView: UIView = {
        let view = UIView()
        
        view.layer.borderColor = UIColor.opaqueSeparator.cgColor
        view.layer.borderWidth = 2.0
        
        view.addSubview(dietTitleLabel)
        dietTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 15)
        
        view.addSubview(checkboxButton1)
        checkboxButton1.anchor(top: dietTitleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(dietVegetarian)
        dietVegetarian.anchor(top: dietTitleLabel.bottomAnchor, left: checkboxButton1.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton2)
        checkboxButton2.anchor(top: checkboxButton1.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(dietVegan)
        dietVegan.anchor(top: dietVegetarian.bottomAnchor, left: checkboxButton2.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton3)
        checkboxButton3.anchor(top: checkboxButton2.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(dietPaleo)
        dietPaleo.anchor(top: dietVegan.bottomAnchor, left: checkboxButton3.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        // Add dietary restrictions + connection to personal data
        
        return view
    }()
    
    let dietTitleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Dietary Restrictions"
        label.font = UIFont(name: "Comfortaa", size: 24)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton1: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getVegetarian())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetVegetarian(sender:)), for: .touchUpInside)
        return button
    }()
    
    let dietVegetarian: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "VEGETARIAN"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton2: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getVegan())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetVegan(sender:)), for: .touchUpInside)
        return button
    }()
    
    let dietVegan: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "VEGAN"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton3: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getPaleo())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetPaleo(sender:)), for: .touchUpInside)
        return button
    }()
    
    let dietPaleo: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "PALEO"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    // MARK: - Allergies
    lazy var allergyContainerView: UIView = {
        let view = UIView()
        
        view.addSubview(allergyTitleLabel)
        allergyTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 15)
        
        // Add allergies + connection to personal data
        
        view.addSubview(checkboxButton4)
        checkboxButton4.anchor(top: allergyTitleLabel.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(allergyDairy)
        allergyDairy.anchor(top: allergyTitleLabel.bottomAnchor, left: checkboxButton4.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton5)
        checkboxButton5.anchor(top: checkboxButton4.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(allergyGluten)
        allergyGluten.anchor(top: allergyDairy.bottomAnchor, left: checkboxButton4.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton6)
        checkboxButton6.anchor(top: checkboxButton5.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height: 24)
        
        view.addSubview(allergyWheat)
        allergyWheat.anchor(top: allergyGluten.bottomAnchor, left: checkboxButton6.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton7)
        checkboxButton7.anchor(top:checkboxButton6.bottomAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 10, width: 24, height:24)
        
        view.addSubview(allergySugar)
        allergySugar.anchor(top: allergyWheat.bottomAnchor, left: checkboxButton7.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        view.addSubview(checkboxButton8)
        checkboxButton8.anchor(top: allergyTitleLabel.bottomAnchor, left: checkboxButton4.rightAnchor, paddingTop: 15, paddingLeft: 175, width: 24, height: 24)
        
        view.addSubview(allergyEgg)
        allergyEgg.anchor(top: allergyTitleLabel.bottomAnchor, left: checkboxButton8.rightAnchor, paddingTop: 20, paddingLeft: 15)

        view.addSubview(checkboxButton9)
        checkboxButton9.anchor(top: checkboxButton8.bottomAnchor, left: checkboxButton5.rightAnchor, paddingTop: 15, paddingLeft: 175, width: 24, height: 24)

        view.addSubview(allergyPeanut)
        allergyPeanut.anchor(top: allergyEgg.bottomAnchor, left: checkboxButton9.rightAnchor, paddingTop: 20, paddingLeft: 15)

        view.addSubview(checkboxButton10)
        checkboxButton10.anchor(top: checkboxButton5.bottomAnchor, left: checkboxButton6.rightAnchor, paddingTop: 15, paddingLeft: 175, width: 24, height: 24)

        view.addSubview(allergyTreeNut)
        allergyTreeNut.anchor(top: allergyPeanut.bottomAnchor, left: checkboxButton10.rightAnchor, paddingTop: 20, paddingLeft: 15)

        view.addSubview(checkboxButton11)
        checkboxButton11.anchor(top:checkboxButton6.bottomAnchor, left: checkboxButton7.rightAnchor, paddingTop: 15, paddingLeft: 175, width: 24, height:24)

        view.addSubview(allergyShellfish)
        allergyShellfish.anchor(top: allergyTreeNut.bottomAnchor, left: checkboxButton11.rightAnchor, paddingTop: 20, paddingLeft: 15)
        
        return view
    }()
    
    let allergyTitleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Allergies"
        label.font = UIFont(name: "Comfortaa", size: 24)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton4: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getDairy())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetDairy(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyDairy: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "DAIRY"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton5: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getGlutenFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetGluten(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyGluten: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "GLUTEN"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton6: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getWheatFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetWheat(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyWheat: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "WHEAT"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton7: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getLowSugar())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetSugar(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergySugar: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "SUGAR"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton8: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getEggFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetEgg(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyEgg: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "EGG"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton9: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getPeanutFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetPeanut(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyPeanut: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "PEANUT"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton10: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getTreeNutFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetTreeNut(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyTreeNut: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "TREE NUT"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton11: UIButton = {
        let button = UIButton(type: .system)
        
        if (PersonalData.getfishFree())
        {
            button.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else
        {
            button.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        button.addTarget(self, action: #selector(handleSetShellfish(sender:)), for: .touchUpInside)
        return button
    }()
    
    let allergyShellfish: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "SHELLFISH"
        label.font = UIFont(name: "Roboto-Black", size: 15)
        label.textColor = .black
        return label
    }()
    
    // Selectors
    
    func updateButtons() {
        
        checkboxButton1.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        checkboxButton2.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        checkboxButton3.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
        
        if (PersonalData.getVegetarian())
        {
            checkboxButton1.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if (PersonalData.getVegan())
        {
            checkboxButton2.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if (PersonalData.getPaleo())
        {
            checkboxButton3.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func handleSetVegetarian(sender: UIButton) {
        PersonalData.setVegetarian(vegetarian: true)
        PersonalData.setVegan(vegan: false)
        PersonalData.setPaleo(paleo:false)
        
        updateButtons()
    }
    
    @objc func handleSetVegan(sender: UIButton) {
        PersonalData.setVegan(vegan: true)
        PersonalData.setVegetarian(vegetarian: false)
        PersonalData.setPaleo(paleo: false)
        
        updateButtons()
    }
    
    @objc func handleSetPaleo(sender: UIButton) {
        PersonalData.setPaleo(paleo: true)
        PersonalData.setVegetarian(vegetarian: false)
        PersonalData.setVegan(vegan: false)
        
        updateButtons()
    }
    
//    @objc func handleSetVegetarian(sender: UIButton) {
//        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
//        {
//            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setVegetarian(vegetarian: true)
//        }
//        else
//        {
//            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setVegetarian(vegetarian: false)
//        }
//    }
//
//    @objc func handleSetVegan(sender: UIButton) {
//        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
//        {
//            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setVegan(vegan: true)
//        }
//        else
//        {
//            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setVegan(vegan: false)
//        }
//    }
//
//    @objc func handleSetPaleo(sender: UIButton) {
//        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
//        {
//            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setPaleo(paleo: true)
//        }
//        else
//        {
//            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
//            PersonalData.setPaleo(paleo: false)
//        }
//    }
    
    @objc func handleSetDairy(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setDairy(dairyFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setDairy(dairyFree: false)
        }
    }
    
    @objc func handleSetGluten(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setGlutenFree(glutenFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setGlutenFree(glutenFree: false)
        }
    }
    
    @objc func handleSetWheat(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setWheatFree(wheatFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setWheatFree(wheatFree: false)
        }
    }
    
    @objc func handleSetSugar(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setLowSugar(lowSugar: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setLowSugar(lowSugar: false)
        }
    }

    @objc func handleSetEgg(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setEggFree(eggFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setEggFree(eggFree: false)
        }
    }
    
    @objc func handleSetPeanut(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setPeanutFree(peanutFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setPeanutFree(peanutFree: false)
        }
    }
    
    @objc func handleSetTreeNut(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setTreeNutFree(treeNutFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setTreeNutFree(treeNutFree: false)
        }
    }
    
    @objc func handleSetShellfish(sender: UIButton) {
        if (sender.currentImage?.isEqualToImage(#imageLiteral(resourceName: "unchecked")) ?? false)
        {
            sender.setImage(#imageLiteral(resourceName: "checked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setfishFree(fishFree: true)
        }
        else
        {
            sender.setImage(#imageLiteral(resourceName: "unchecked").withRenderingMode(.alwaysOriginal), for: .normal)
            PersonalData.setfishFree(fishFree: false)
        }
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "marble2"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.5
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        backgroundImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        view.addSubview(headerContainerView)
        headerContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 400)
        
        view.addSubview(dietContainerView)
        dietContainerView.anchor(top: headerContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        
        view.addSubview(allergyContainerView)
        allergyContainerView.anchor(top: dietContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)

    }
}

// MARK: - Extensions

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha:1)
    }
    
    static let mainBlue = UIColor.rgb(red: 0, green: 150, blue: 255)
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat? = 0, paddingLeft: CGFloat? = 0, paddingBottom: CGFloat? = 0, paddingRight: CGFloat? = 0, width: CGFloat? = nil, height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop!).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft!).isActive = true
        }
        
        if let bottom = bottom {
            if let paddingBottom = paddingBottom {
                bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
            }
        }
        
        if let right = right {
            if let paddingRight = paddingRight {
                rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
            }
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension UIImage {
    
    func isEqualToImage(_ image: UIImage) -> Bool {
        return self.pngData() == image.pngData()
    }
}
