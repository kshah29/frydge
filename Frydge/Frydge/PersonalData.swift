//
//  PersonalData.swift
//  Frydge
//
//  Created by Kanisha Shah on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import Foundation

class PersonalData{
    static var name : String = ""
    static var email : String = ""
    static var isVegan : Bool = false
    static var isVegeterian : Bool = false
    static var isPaleo : Bool = false
    static var isDairyFree : Bool = false
    static var isGlutenFree : Bool = false
    static var isWheatFree : Bool = false
    static var isLowSugar : Bool = false
    static var isEggFree : Bool = false
    static var isPeanutFree : Bool = false
    static var isTreeNutFree : Bool = false
    static var isFishFree : Bool = false
    
    static public func login(userName: String, userEmail: String){
        name = userName
        email = userEmail
    }
    
    static public func setVegan(vegan: Bool){
        isVegan = vegan
    }
    
    static public func setVegeterian(vegeterian: Bool){
        isVegeterian = vegeterian
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
    
    static public func setTreeNutFree(treeNutFree: Bool){
        isTreeNutFree = treeNutFree
    }
    
    static public func setfishFree(fishFree: Bool){
        isFishFree = fishFree
    }
    
    static public func getDietaryRestrictions() -> [String]{
        
        var restrictions : [String] = []
        
        if (isVegan){
            restrictions.append("")
        }
        if (isVegeterian){
            restrictions.append("")
        }
        if (isPaleo){
            restrictions.append("")
        }
        if (isDairyFree){
            restrictions.append("")
        }
        if (isGlutenFree){
            restrictions.append("")
        }
        if (isWheatFree){
            restrictions.append("")
        }
        if (isLowSugar){
            restrictions.append("")
        }
        if (isEggFree){
            restrictions.append("")
        }
        if (isPeanutFree){
            restrictions.append("")
        }
        if (isTreeNutFree){
            restrictions.append("")
        }
        if (isFishFree){
            restrictions.append("")
        }
        
        return restrictions
    }
}
