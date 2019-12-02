//
//  MainTabBarController.swift
//  Frydge
//
//  Created by Ian Costello on 11/3/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup our custom view controllers
        
        tabBar.barTintColor = UIColor(named: "White")
        
        let tabBarHeight = self.tabBar.bounds.height
        let searchVC = RecipeSearchViewController()
        searchVC.tabBarItem.image = UIImage(named: "search.pdf")?.resizedImage(for: CGSize(width: tabBarHeight - 30, height: tabBarHeight - 30))
        
        let profileVC = ProfileViewController()
        profileVC.tabBarItem.image = UIImage(named: "user.pdf")?.resizedImage(for: CGSize(width: tabBarHeight - 30, height: tabBarHeight - 30))
        
        let cookbookVC = CookbookViewController() // cookbook
        let heartImageSize = UIImage(named: "heart.pdf")?.size
        var heartWidth: CGFloat?
        if let heartImageSize = heartImageSize {
            heartWidth = (tabBarHeight - 30) * heartImageSize.width / heartImageSize.height
        }
        cookbookVC.tabBarItem.image = UIImage(named: "heart.pdf")?.resizedImage(for: CGSize(width: heartWidth ?? tabBarHeight - 30, height: tabBarHeight - 30))
        
        let pantryVC = PantryViewController(collectionViewLayout: UICollectionViewFlowLayout())
        pantryVC.tabBarItem.image = UIImage(named: "pantry2.pdf")?.resizedImage(for: CGSize(width: tabBarHeight - 22, height: tabBarHeight - 22))

        viewControllers = [searchVC, cookbookVC, pantryVC, profileVC]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String?) -> UINavigationController {
        let vc = UIViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        let tabBarHeight = self.tabBar.bounds.height
        if let imageName = imageName {
            navController.tabBarItem.image = UIImage(named: imageName)?.resizedImage(for: CGSize(width: tabBarHeight - 20, height: tabBarHeight - 20))
        }
        return navController
    }

}

extension UIImage {
    func resizedImage(for size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIColor {
    public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h, s, b, a)
    }
    
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
