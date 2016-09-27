//
//  LoginController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/27/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController : UIViewController{

    @IBOutlet weak var usernameField : TranslucentTextField!
    @IBOutlet weak var passwordField : TranslucentTextField!
    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField?.placeholderText = "Username"
        passwordField?.placeholderText = "Password"
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderColor = UIColor.lightText.cgColor
        
        usernameField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    
    func textFieldDidChange(_ textField : UITextField!){
        if let username = usernameField.text , !username.isEmpty, let password = passwordField.text , !password.isEmpty{
        loginButton.setTitleColor(UIColor.white, for: UIControlState())
            loginButton.isEnabled = true
        }else{
            loginButton.setTitleColor(UIColor.lightText, for: .disabled)
            loginButton.isEnabled = false
        }
    }
    func login(_ email: String, password: String){
    
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { response, error in
            
            if error != nil{
            print(error?.localizedDescription)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let uid = response?.uid
            usernameRef.child(uid!).observeSingleEvent(of: .value, with: { snapshot in
                
                guard let username = snapshot.value as? String else{
                print("No user found for \(email)")
                self.activityIndicator.stopAnimating()
                return
                }
                
                profileRef.child(username).observeSingleEvent(of: .value, with: {
                snapshot in
                    self.activityIndicator?.stopAnimating()
                    
                    guard let profile = snapshot.value as? [String: AnyObject] else{
                    print("No profile found for user")
                        return
                    }
                Profile.currentUser = Profile.initWithUsername(username, profileDict: profile)
                    let mainSB = UIStoryboard(name:"Main", bundle: Bundle.main)
                    let rootController = mainSB.instantiateViewController(withIdentifier: "Tabs")
                    self.present(rootController, animated: true, completion: nil)
                })
            })
            
        })
        
        
          }
    
    @IBAction func loginTapped(_ sender : UIButton!){
        guard let username = usernameField?.text , !username.isEmpty, let password = passwordField?.text , !password.isEmpty else{
            return
        }
        activityIndicator?.startAnimating()
        login(username, password: password)
    
    }
    
    @IBAction func signupTapped(_ sender : UIButton!){
    
        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        let registerController = mainSB.instantiateViewController(withIdentifier: "Register") as! RegisterController
        registerController.delegate = self
        present(registerController, animated: true, completion: nil)
    }
}

extension LoginController : RegisterControllerDelegate{

    func registerControllerDidCancel(_ registerController: RegisterController) {
        registerController.dismiss(animated: true, completion: nil)
    }
    func registerControllerDidFinish(_ registerController: RegisterController, withEmail email: String) {
        usernameField.text = email
        registerController.dismiss(animated: true, completion: nil)
    }
}
