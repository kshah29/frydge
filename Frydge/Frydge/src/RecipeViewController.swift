//
//  RecipeViewController.swift
//  Frydge
//
//  Created by Ian Costello on 11/14/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    var recipe: Recipe?
    var backgroundImage: UIImageView?
    var scrollView = UIScrollView(frame: .zero)
    var scrollContentView = UIView(frame: .zero)
    var titleView: UIView?
    var timeView: UIView?
    var processView: UIView?
    
    init(forRecipe recipe: Recipe) {
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        guard let recipe = recipe else { return }
        if recipe.image != nil {
            backgroundImage = UIImageView(image: recipe.image)
            if let backgroundImage = backgroundImage {
                backgroundImage.frame = view.frame
                backgroundImage.contentMode = .scaleAspectFill
                
//                let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//                frost.frame = backgroundImage.frame
//                backgroundImage.insertSubview(frost, at: 0)
                
                let fadeView = UIView(frame: backgroundImage.frame)
                fadeView.backgroundColor = .white
                fadeView.alpha = 0.5
                backgroundImage.addSubview(fadeView)
                view.addSubview(backgroundImage)
            }
        }
        
        titleView = createTitleView()
        timeView = createTimeView()
        processView = createProcessView()
        guard let titleView = titleView, let timeView = timeView, let processView = processView else { return }
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        timeView.translatesAutoresizingMaskIntoConstraints = false
        processView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.isDirectionalLockEnabled = true
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleView)
        scrollContentView.addSubview(timeView)
        scrollContentView.addSubview(processView)
        
        scrollView.constrainToContainer(container: view, padding: 0)
        let timeViewHeight: CGFloat = (recipe.preppingTime == nil && recipe.cookingTime == nil) ? 0 : 68
        if timeViewHeight == 0 { timeView.isHidden = true }
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: processView.bottomAnchor, constant: 20),
            
            titleView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20),
            titleView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor, constant: -40),
            titleView.heightAnchor.constraint(equalToConstant: 100),
            
            timeView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            timeView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            timeView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor, constant: -40),
            timeView.heightAnchor.constraint(equalToConstant: timeViewHeight),
            
            processView.topAnchor.constraint(equalTo: timeView.bottomAnchor, constant: 10),
            processView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            processView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor, constant: -40),
            processView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = scrollContentView.frame.size
    }
    
    func createTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let label = UILabel()
        label.text = recipe?.title
        label.font = UIFont(name: "Comfortaa", size: 35)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.constrainToContainer(container: view, padding: 10)
        return view
    }
    
    func createTimeView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let timeIcon = UIImageView(image: #imageLiteral(resourceName: "time"))
        timeIcon.tintColor = .black
        timeIcon.contentMode = .scaleAspectFit
        timeIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        if let prepTime = recipe?.preppingTime, let cookTime = recipe?.cookingTime {
            label.text = "Prep time: \(prepTime) minutes" + "\n" + "Cook time: \(cookTime) minutes"
        }
        else if let prepTime = recipe?.preppingTime {
            label.text = "Prep time: \(prepTime) minutes "
        }
        else if let cookTime = recipe?.cookingTime {
            label.text = "Cook time: \(cookTime) minutes"
        }
        label.font = UIFont(name: "Comfortaa", size: 20)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .left
        
        view.addSubview(label)
        view.addSubview(timeIcon)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeIcon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            timeIcon.heightAnchor.constraint(equalToConstant: 30),
            timeIcon.widthAnchor.constraint(equalTo: timeIcon.heightAnchor),
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: timeIcon.rightAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            
        ])
        return view
    }
    
    func createProcessView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.alpha = 0.8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        let processLabel = UILabel()
        processLabel.text = "Instructions"
        processLabel.font = UIFont(name: "Comfortaa", size: 28)
        processLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dividerView = UIView()
        dividerView.backgroundColor = .black
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        var steps: [String] = []
        for (i, step) in recipe?.process.enumerated() ?? [].enumerated() {
            let string = "\(i + 1).\t\(step)"
            steps.append(string)
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont(name: "Comfortaa", size: 20)
        attributes[.foregroundColor] = UIColor.darkGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = ("\t").size(withAttributes: attributes).width
        attributes[.paragraphStyle] = paragraphStyle

        let string = steps.joined(separator: "\n\n")
        label.attributedText = NSAttributedString(string: string, attributes: attributes)
        
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        
        view.addSubview(processLabel)
        view.addSubview(label)
        view.addSubview(dividerView)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            processLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            processLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            processLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0),
            processLabel.heightAnchor.constraint(equalToConstant: 30),
            
            dividerView.topAnchor.constraint(equalTo: processLabel.bottomAnchor),
            dividerView.leftAnchor.constraint(equalTo: processLabel.leftAnchor),
            dividerView.rightAnchor.constraint(equalTo: processLabel.rightAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            label.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        return view
    }
}

extension UIView {
    func constrainToContainer(container: UIView, padding: CGFloat?) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: padding ?? 0),
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: padding ?? 0),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -1 * (padding ?? 0)),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -1 * (padding ?? 0))
        ])
    }
}
