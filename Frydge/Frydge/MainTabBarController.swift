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

        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.tintColor = .white
        // Setup our custom view controllers
        
//        let tabBarHeight = self.tabBar.bounds.height
        
        viewControllers = [createDummyNavControllerWithTitle(title: "Search", imageName: nil), createDummyNavControllerWithTitle(title: "Cookbook", imageName: nil), createDummyNavControllerWithTitle(title: "Pantry", imageName: nil), createDummyNavControllerWithTitle(title: "Profile", imageName: nil)]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String?) -> UINavigationController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        let tabBarHeight = self.tabBar.bounds.height
        if let imageName = imageName {
            navController.tabBarItem.image = UIImage(named: imageName)?.resizedImage(for: CGSize(width: tabBarHeight - 20, height: tabBarHeight - 20))
        }
        navController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        navController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

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

