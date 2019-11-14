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
    
    lazy var headerContainerView: UIView = {
        let view = UIView()
        
//        view.backgroundColor = .blue
        
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
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "avatar2")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "User 1234"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .black
        return label
    }()
    
    let membershipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "member since Nov. 2019"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var dietContainerView: UIView = {
        let view = UIView()
        
//        view.backgroundColor = .red
        
        view.layer.borderColor = UIColor.opaqueSeparator.cgColor
        view.layer.borderWidth = 2.0
        
        view.addSubview(dietTitleLabel)
        dietTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 15)
        
        view.addSubview(checkboxButton)
        checkboxButton.anchor(top: dietTitleLabel.bottomAnchor, paddingTop: 10, paddingLeft: 10, width: 32, height: 32)
        
        view.addSubview(dietX)
        dietX.anchor(top: dietTitleLabel.bottomAnchor, left: checkboxButton.rightAnchor, paddingTop: 10, paddingLeft: 15)
        
        // Add dietary restrictions + connection to personal data
        
        return view
    }()
    
    lazy var allergyContainerView: UIView = {
        let view = UIView()
        
//        view.backgroundColor = .white
        
        view.addSubview(allergyTitleLabel)
        allergyTitleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 25)
        
        // Add allergies + connection to personal data
        
        return view
    }()
    
    let dietTitleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Dietary Restrictions"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    let allergyTitleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.text = "Allergies"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
    
    let checkboxButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "unchecked-1").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let dietX: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "X"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = .black
        return label
    }()
        
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
