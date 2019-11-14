//
//  FrydgeTests.swift
//  FrydgeTests
//
//  Created by Megan Hong on 11/13/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import XCTest
@testable import Frydge

class FrydgeTests: XCTestCase {
    
    private var recipe1 : Recipe!
    private var recipe2 : Recipe!
    private var recipe3 : Recipe!

    override func setUp() {
        recipe1 = Recipe(id: 100, title: "Recipe Title 1", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process1", image: "imageUrl1");
        recipe2 = Recipe(id: 200, title: "Recipe Title 2", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process2", image: "imageUrl2");
        recipe3 = Recipe(id: 300, title: "Recipe Title 3", ingredientList: [Ingredient(name: "i1", amount: 1), Ingredient(name: "i2", amount: 2)], process: "process3", image: "imageUrl3");
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    fun testCase {
        
    }

    
}
