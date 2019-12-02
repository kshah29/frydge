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
    static var name : String = "placeholder_name"
    static var email : String = ""
    static var membershipDate : String = "placeholder_date"
    static var profileImage : UIImage = #imageLiteral(resourceName: "avatar2")
    static var isVegan : Bool = false
    static var isVegetarian : Bool = false
    static var isPaleo : Bool = false
    static var isDairyFree : Bool = false
    static var isGlutenFree : Bool = false
    static var isWheatFree : Bool = false
    static var isLowSugar : Bool = false
    static var isEggFree : Bool = false
    static var isPeanutFree : Bool = false
    static var isFishFree : Bool = false
    
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
}
