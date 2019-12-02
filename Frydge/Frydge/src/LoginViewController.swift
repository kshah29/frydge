//
//  LoginViewController.swift
//  Frydge
//
//  Created by Ian Costello on 11/28/19.
//  Copyright © 2019 Frydge Co. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let backgroundImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "marble"))
        iv.contentMode = .scaleAspectFill
        iv.alpha = 0.5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let logo: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "frydge"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Frydge"
        label.font = UIFont(name: "Comfortaa", size: 48)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginCard: LoginCard = LoginCard()
    let loginErrorCard: LoginErrorCard = {
        let card = LoginErrorCard(error: "")
        card.isHidden = true
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let user = defaults.string(forKey: "loggedInUser") {
            if let validLogins = readPropertyList(path: "ExampleUsers"), let userList = validLogins["Users"] as? [[String:Any]] {
                handleSuccessfulLogin(username: user, userList: userList, loginCompletion: {})
            }
        }
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        loginCard.userField.delegate = self
        loginCard.passField.delegate = self
        
        view.addSubview(backgroundImage)
        view.addSubview(logo)
        view.addSubview(titleLabel)
        view.addSubview(loginCard)
        view.addSubview(loginErrorCard)
        
        let safeGuide = self.view.safeAreaLayoutGuide
        backgroundImage.constrainToContainer(container: view, padding: 0)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 40),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 110),
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 52),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            loginCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            loginCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginCard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginCard.heightAnchor.constraint(equalToConstant: 220),
            
            loginErrorCard.topAnchor.constraint(equalTo: loginCard.bottomAnchor, constant: 20),
            loginErrorCard.widthAnchor.constraint(equalTo: loginCard.widthAnchor),
            loginErrorCard.heightAnchor.constraint(equalToConstant: 60),
            loginErrorCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    enum loginError {
        case emptyField
        case invalidUserInfo
    }
    @objc func loginAction(sender: UIButton) {
        guard let validLogins = readPropertyList(path: "ExampleUsers") else {
            print("Failed to read property list ExampleUsers")
            return
        }
        
        let userInput = loginCard.userField.text
        let passInput = loginCard.passField.text
        if userInput != "" && passInput != "" {
            if let userList = validLogins["Users"] as? [[String:Any]] {
                for user in userList {
                    if let username = user["Username"] as? String, let password = user["Password"] as? String {
                        if username == userInput && password == passInput {
                            handleSuccessfulLogin(username: username, userList: userList, loginCompletion: {
                                self.loginCard.stopActivityIndicator()
                            })
                            return
                        }
                    }
                }
                // Did not find a matching login
                handleFailedLogin(error: .invalidUserInfo)
            } else {
                print("Failed to read list of users")
            }
        }
        else {
            handleFailedLogin(error: .emptyField)
        }
    }
    
    func handleSuccessfulLogin(username: String, userList: [[String : Any]], loginCompletion: @escaping () -> ()) {
        PersonalData.setPersonalDataFromSuccessfulLogin(username: username)
        RecipeStore.setRecipeStoreFromSuccessfulLogin(username: username)
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "loggedInUser")
        let mainVC = MainTabBarController()
        self.navigationController?.pushViewController(viewController: mainVC, animated: true, completion: {
            loginCompletion()
        })
    }
    func handleFailedLogin(error: loginError) {
        var errorString: String
        switch error {
        case .emptyField:
            errorString = "Both fields are required."
        case .invalidUserInfo:
            errorString = "Incorrect username or password."
        }
        
        loginErrorCard.errorLabel.text = errorString
        loginErrorCard.isHidden = false
        loginErrorCard.shake()
    }
    func startActivityIndicator() {
        loginCard.startActivityIndicator()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            loginCard.passField.becomeFirstResponder()
        }
        else {
            loginAction(sender: loginCard.loginButton)
        }
        
        return true
    }
    
    class LoginCard: UIView {
        let userField = LoginTextField(placeholderText: "Username", isSecure: false)
        let passField = LoginTextField(placeholderText: "Password", isSecure: true)
        let loginButton: LoginPageMainButton = {
            let button = LoginPageMainButton(buttonTitle: "Login")
            button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
            return button
        }()
        let activityIndicator: UIActivityIndicatorView = {
            let actInd = UIActivityIndicatorView(style: .large)
            actInd.hidesWhenStopped = true
            actInd.color = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.6)
            actInd.translatesAutoresizingMaskIntoConstraints = false
            return actInd
        }()
        
        init() {
            super.init(frame: .zero)
            
            backgroundColor = .white
            layer.cornerRadius = 10
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 0, height: 0)
            translatesAutoresizingMaskIntoConstraints = false
            
            userField.returnKeyType = .next
            passField.returnKeyType = .go
            userField.tag = 0
            passField.tag = 1
            
            addSubview(userField)
            addSubview(passField)
            addSubview(loginButton)
            addSubview(activityIndicator)
            
            // Total height: 220
            NSLayoutConstraint.activate([
                userField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                userField.centerXAnchor.constraint(equalTo: centerXAnchor),
                userField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
                userField.heightAnchor.constraint(equalToConstant: 40),
                
                passField.topAnchor.constraint(equalTo: userField.bottomAnchor, constant: 20),
                passField.centerXAnchor.constraint(equalTo: centerXAnchor),
                passField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
                passField.heightAnchor.constraint(equalToConstant: 40),
                
                loginButton.topAnchor.constraint(equalTo: passField.bottomAnchor, constant: 20),
                loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                loginButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
                loginButton.heightAnchor.constraint(equalToConstant: 60),
                
                activityIndicator.topAnchor.constraint(equalTo: loginButton.topAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
                activityIndicator.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
                activityIndicator.widthAnchor.constraint(equalTo: activityIndicator.heightAnchor),
            ])
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func startActivityIndicator() {
            if activityIndicator.isAnimating { return }
            activityIndicator.startAnimating()
            loginButton.titleLabel?.isHidden = true
            loginButton.isEnabled = false
        }
        func stopActivityIndicator() {
            if !activityIndicator.isAnimating { return }
            activityIndicator.stopAnimating()
            loginButton.titleLabel?.isHidden = false
            loginButton.isEnabled = true
        }

        class LoginTextField: UITextField {
            init(placeholderText: String, isSecure: Bool) {
                super.init(frame: .zero)
                
                attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6185787671, green: 0.6185787671, blue: 0.6185787671, alpha: 1)])
                backgroundColor = #colorLiteral(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                textColor = .black
                layer.cornerRadius = 20
                translatesAutoresizingMaskIntoConstraints = false
                
                isSecureTextEntry = isSecure
                
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.size.height))
                leftView = paddingView
                leftViewMode = .always
                rightView = paddingView
                rightViewMode = .always
            }
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        class LoginPageMainButton: UIButton {
            init(buttonTitle: String) {
                super.init(frame: .zero)
                let color: UIColor = .white
                setTitle(buttonTitle, for: .normal)
                setTitleColor(color, for: .normal)
                titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                setTitleColor(UIColor(hue: color.hsba.hue, saturation: color.hsba.saturation, brightness: color.hsba.brightness, alpha: 0.6), for: .highlighted)
                setTitleColor(.clear, for: .disabled)
                setBackgroundImage(#colorLiteral(red: 1, green: 0.2235294118, blue: 0.2980392157, alpha: 1).image(), for: .normal)
                layer.masksToBounds = true
                layer.cornerRadius = 30
                translatesAutoresizingMaskIntoConstraints = false
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
    }
    
    class LoginErrorCard: UIView {
        
        let errorSymbol: UIImageView = {
            let iv = UIImageView(image: #imageLiteral(resourceName: "Error"))
            iv.contentMode = .scaleAspectFit
            iv.tintColor = #colorLiteral(red: 0.9990366101, green: 0.2231199145, blue: 0.2992112637, alpha: 1)
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        let errorLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
            label.textColor = #colorLiteral(red: 0.9990366101, green: 0.2231199145, blue: 0.2992112637, alpha: 1)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        init(error: String) {
            super.init(frame: .zero)

            backgroundColor = .white
            layer.cornerRadius = 10
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowRadius = 8
            layer.shadowOffset = CGSize(width: 0, height: 0)
            translatesAutoresizingMaskIntoConstraints = false

            addSubview(errorLabel)
            addSubview(errorSymbol)
            errorLabel.text = error
            
            NSLayoutConstraint.activate([
                errorSymbol.centerYAnchor.constraint(equalTo: centerYAnchor),
                errorSymbol.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                errorSymbol.widthAnchor.constraint(equalToConstant: 30),
                errorSymbol.heightAnchor.constraint(equalTo: errorSymbol.widthAnchor),
                
                errorLabel.topAnchor.constraint(equalTo: topAnchor),
                errorLabel.leftAnchor.constraint(equalTo: errorSymbol.rightAnchor, constant: 10),
                errorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
       }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

// From https://stackoverflow.com/questions/24045570/how-do-i-get-a-plist-as-a-dictionary-in-swift
func readPropertyList(path: String) -> [String:AnyObject]? {
    var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
    var plistData: [String: AnyObject] = [:] //Our data
    let plistPath: String? = Bundle.main.path(forResource: path, ofType: "plist")! //the path of the data
    let plistXML = FileManager.default.contents(atPath: plistPath!)!
    do {//convert the data to a dictionary and handle errors.
        plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
        return plistData

    } catch {
        print("Error reading plist: \(error), format: \(propertyListFormat)")
        return nil
    }
}

// From https://github.com/soonin/IOS-Swift-PlistReadAndWrite/blob/master/IOS-Swift-PlistReadAndWrite/PlistReadAndWrite.swift
func writePlist(namePlist: String, key: String, data: AnyObject){
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentsDirectory = paths.object(at: 0) as! NSString
    let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
    
    if let dict = NSMutableDictionary(contentsOfFile: path){
        dict.setObject(data, forKey: key as NSCopying)
        if dict.write(toFile: path, atomically: true){
            print("plist_write")
        }else{
            print("plist_write_error")
        }
    }else{
        if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
            if let dict = NSMutableDictionary(contentsOfFile: privPath){
                dict.setObject(data, forKey: key as NSCopying)
                if dict.write(toFile: path, atomically: true){
                    print("plist_write")
                }else{
                    print("plist_write_error")
                }
            }else{
                print("plist_write")
            }
        }else{
            print("error_find_plist")
        }
    }
}
func readPlist(namePlist: String, key: String) -> AnyObject{
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    let documentsDirectory = paths.object(at: 0) as! NSString
    let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
    
    var output:AnyObject = false as AnyObject
    
    if let dict = NSMutableDictionary(contentsOfFile: path){
        output = dict.object(forKey: key)! as AnyObject
    }else{
        if let privPath = Bundle.main.path(forResource: namePlist, ofType: "plist"){
            if let dict = NSMutableDictionary(contentsOfFile: privPath){
                output = dict.object(forKey: key)! as AnyObject
            }else{
                output = false as AnyObject
                print("error_read")
            }
        }else{
            output = false as AnyObject
            print("error_read")
        }
    }
//    print("plist_read \(output)")
    return output
}

extension UINavigationController {
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

// From http://www.gamesforgeeks.com/2017/11/creating-a-shaking-password-text-field/
extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
