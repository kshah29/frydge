//
//  PersonalData.swift
//  Frydge
//
//  Created by Kanisha Shah on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation
import UIKit

class PersonalData{
    private enum PersonalDataType {
        case dietaryRestriction
        case allergy
    }
    private static var username : String = ""
    static var name : String = "placeholder_name"
    static var email : String = ""
    static var membershipDate : String = "placeholder_date"
    static var profileImage : UIImage = #imageLiteral(resourceName: "avatar2")
    static var isVegan : Bool = false {
        didSet {
            writeData(data: [
                "Vegan": isVegan,
                "Vegetarian": isVegetarian,
                "Paleo": isPaleo
            ], type: .dietaryRestriction)
        }
    }
    static var isVegetarian : Bool = false
    static var isPaleo : Bool = false
    static var isDairyFree : Bool = false {
        didSet {
            writeData(data: ["Dairy": isDairyFree], type: .allergy)
        }
    }
    static var isGlutenFree : Bool = false {
       didSet {
           writeData(data: ["Gluten": isGlutenFree], type: .allergy)
       }
   }
    static var isWheatFree : Bool = false {
        didSet {
          writeData(data: ["Wheat": isWheatFree], type: .allergy)
        }
    }
    static var isLowSugar : Bool = false {
        didSet {
          writeData(data: ["Sugar": isLowSugar], type: .allergy)
        }
    }
    static var isEggFree : Bool = false {
        didSet {
          writeData(data: ["Egg": isEggFree], type: .allergy)
        }
    }
    static var isPeanutFree : Bool = false {
        didSet {
          writeData(data: ["Peanut": isPeanutFree], type: .allergy)
        }
    }
//    static var isTreeNutFree : Bool = false
    static var isFishFree : Bool = false {
        didSet {
          writeData(data: ["Shellfish": isFishFree], type: .allergy)
        }
    }
    
    static public func login(userName: String, userEmail: String){
        name = userName
        email = userEmail
    }
    
    // call on first login
    static public func setMembershipDate() {
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM yyyy"
        
        membershipDate = formatter.string(from: date)
    }
    
    static public func getName() -> String {
        return name
    }
    
    static public func getMembershipDate() -> String {
        return membershipDate
    }
    
    static public func getProfileImage() -> UIImage {
        return profileImage
    }
    
    static public func getVegan() -> Bool {
        return isVegan
    }
    
    static public func getVegetarian() -> Bool {
        return isVegetarian
    }
    
    static public func getPaleo() -> Bool {
        return isPaleo
    }
    
    static public func getDairy() -> Bool {
        return isDairyFree
    }
    
    static public func getGlutenFree() -> Bool {
        return isGlutenFree
    }
    
    static public func getWheatFree() -> Bool {
        return isWheatFree
    }
    
    static public func getLowSugar() -> Bool {
        return isLowSugar
    }
    
    static public func getEggFree() -> Bool {
        return isEggFree
    }
    
    static public func getPeanutFree() -> Bool {
        return isPeanutFree
    }
    
    static public func getfishFree() -> Bool {
        return isFishFree
    }
    
    static public func setVegan(vegan: Bool){
        isVegan = vegan
    }
    
    static public func setVegetarian(vegetarian: Bool){
        isVegetarian = vegetarian
    }
    
    static public func setPaleo(paleo: Bool){
        isPaleo = paleo
    }
    
    static public func setDairy(dairyFree: Bool){
        isDairyFree = dairyFree
    }
    
    static public func setGlutenFree(glutenFree: Bool){
        isGlutenFree = glutenFree
    }
    
    static public func setWheatFree(wheatFree: Bool){
        isWheatFree = wheatFree
    }
    
    static public func setLowSugar(lowSugar: Bool){
        isLowSugar = lowSugar
    }
    
    static public func setEggFree(eggFree: Bool){
        isEggFree = eggFree
    }
    
    static public func setPeanutFree(peanutFree: Bool){
        isPeanutFree = peanutFree
    }
    
    static public func setfishFree(fishFree: Bool){
        isFishFree = fishFree
    }
    
    static public func getIntoleranceString() -> String{
        var intolerances : String = ""
        
        if (isDairyFree){
            intolerances = "Dairy"
        }
        if (isGlutenFree){
            if intolerances == "" {
                intolerances = "Gluten"
            }
            else {
                intolerances += ",Gluten"
            }
        }
        if (isWheatFree){
            if intolerances == "" {
                intolerances = "Wheat"
            }
            else {
                intolerances += ",Wheat"
            }
        }
        if (isLowSugar){
            if intolerances == "" {
                intolerances = "Sugar"
            }
            else {
                intolerances += ",Sugar"
            }
        }
        if (isEggFree){
            if intolerances == "" {
                intolerances = "Egg"
            }
            else {
                intolerances += ",Egg"
            }
        }
        if (isPeanutFree){
            if intolerances == "" {
                intolerances = "Peanut"
            }
            else {
                intolerances += ",Peanut"
            }
        }
        if (isFishFree){
            if intolerances == "" {
                intolerances = "Shellfish"
            }
            else {
                intolerances += ",Shellfish"
            }
        }
        
        return intolerances
    }
    
    static public func getDietaryRestrictions() -> String{
        
        var diet : String = ""
       

        if (isVegetarian){
            diet = "Vegetarian"
        }
        if (isVegan){
            diet = "Vegan"
        }
        if (isPaleo){
            diet = "Paleo"
        }
        
        return diet
    }
    
    static public func setPersonalDataFromSuccessfulLogin(username: String) {
        var userData: [String:Any]?
        let userList = readPlist(namePlist: "ExampleUsers", key: "Users") as! [[String:Any]]
        for user in userList {
            if username == (user["Username"] as? String ?? "") {
                userData = user["Personal Data"] as? [String:Any]
                break
            }
        }
        guard let data = userData else { return }
        
        if let u_name = data["Name"] as? String, let u_date = data["Date Joined"] as? String, let u_dietaryRestrictions = data["Dietary Restrictions"] as? [String:Bool], let u_allergies = data["Allergies"] as? [String:Bool] {
            if let u_vegan = u_dietaryRestrictions["Vegan"], let u_vegetarian = u_dietaryRestrictions["Vegetarian"], let u_paleo = u_dietaryRestrictions["Paleo"], let u_dairy = u_allergies["Dairy"], let u_egg = u_allergies["Egg"], let u_gluten = u_allergies["Gluten"], let u_peanut = u_allergies["Peanut"], let u_wheat = u_allergies["Wheat"], let u_shellfish = u_allergies["Shellfish"], let u_sugar = u_allergies["Sugar"] {
                
                name = u_name; membershipDate = u_date
                isVegan = u_vegan; isVegetarian = u_vegetarian; isPaleo = u_paleo
                isDairyFree = u_dairy; isEggFree = u_egg; isGlutenFree = u_gluten; isPeanutFree = u_peanut; isWheatFree = u_wheat; isFishFree = u_shellfish; isLowSugar = u_sugar
                self.username = username
            }
        }
    }
    
    private static func writeData(data: [String:Bool], type: PersonalDataType) {
        guard data.count > 0 else { return }
        let readUsers = readPlist(namePlist: "ExampleUsers", key: "Users") as! [[String:Any]]
        if var userList = readUsers as? [[String:Any]] {
            var userObject: [String: Any]?
            var userData: [String:Any]?
            var index = 0
            for user in userList {
                if username == (user["Username"] as? String ?? "") {
                    userObject = user
                    userData = user["Personal Data"] as? [String:Any]
                    break
                }
                index += 1
            }
            if userData == nil { return }
            if type == .dietaryRestriction {
                if var restrictions = userData!["Dietary Restrictions"] as? [String:Bool] {
                    for (key, val) in data {
                        restrictions[key] = val
                    }
                    userData!["Dietary Restrictions"] = restrictions
                    userObject!["Personal Data"] = userData
                    userList[index] = userObject!
                    writePlist(namePlist: "ExampleUsers", key: "Users", data: userList as AnyObject)
                }
            }
            else {
                if var allergies = userData!["Allergies"] as? [String:Bool] {
                    for (key, val) in data {
                        allergies[key] = val
                    }
                    userData!["Allergies"] = allergies
                    userObject!["Personal Data"] = userData
                    userList[index] = userObject!
                    writePlist(namePlist: "ExampleUsers", key: "Users", data: userList as AnyObject)
                }
            }
        }
    }
}
