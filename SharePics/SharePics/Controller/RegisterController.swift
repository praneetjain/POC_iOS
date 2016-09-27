//
//  RegisterController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/27/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol RegisterControllerDelegate : class {
    func registerControllerDidCancel(_ registerController : RegisterController)
    func registerControllerDidFinish(_ registerController : RegisterController, withEmail email: String)
}
class RegisterController : UIViewController{
    @IBOutlet weak var emailField : TranslucentTextField!
    @IBOutlet weak var passwordField : TranslucentTextField!
    @IBOutlet weak var usernameField : TranslucentTextField!
    @IBOutlet weak var registerButton : UIButton!
    weak var delegate : RegisterControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.placeholderText = "Email"
        passwordField.placeholderText = "Password"
        usernameField.placeholderText = "Username"
        
        registerButton.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderColor = UIColor.lightText.cgColor

        emailField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)
        usernameField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), for: .editingChanged)

    }
    
    func textFieldDidChange(_ textField : UITextField!){
        if let username = usernameField.text , !username.isEmpty, let password = passwordField.text , !password.isEmpty, let email = emailField.text , !email.isEmpty{
            registerButton.setTitleColor(UIColor.white, for: UIControlState())
            registerButton.isEnabled = true
        }else{
            registerButton.setTitleColor(UIColor.lightText, for: .disabled)
            registerButton.isEnabled = false
        }
    }
    @IBAction func registerTapped(_ sender : UIButton!){
    
        guard let email = emailField?.text , !email.isEmpty, let password = passwordField?.text , !password.isEmpty, let username = usernameField?.text , !username.isEmpty else{
        return
        }
    
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { result, error in
            if error != nil{
            
                print("Error occured during registration \(error?.localizedDescription)")
            return
            }
            
            guard let uid = result?.uid else{
            
                print("Invalid username for user \(email)")
                return
            }
            
            usernameRef.child(uid).setValue(username)
            profileRef.child(username).setValue(["username":username])
            let alertController = UIAlertController(title: "Registration Success!", message: "Your account was successfully created using email \(email)", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: {
            alertAction in
            //go to login controller and pass the email id for sign up
                self.delegate?.registerControllerDidFinish(self, withEmail: email)
            })
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }

    @IBAction func loginTapped(_ sender : UIButton!){
    delegate?.registerControllerDidCancel(self)
    }
    
}
