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
        
        tabBar.barTintColor = UIColor(named: "Blue")
        viewControllers = [createDummyNavControllerWithTitle(title: "Search", imageName: nil), createDummyNavControllerWithTitle(title: "Cookbook", imageName: nil), createDummyNavControllerWithTitle(title: "Pantry", imageName: nil), createDummyNavControllerWithTitle(title: "Profile", imageName: nil)]
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
        navController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.5)], for: .normal)
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

