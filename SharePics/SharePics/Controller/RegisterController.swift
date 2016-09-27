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
    func registerControllerDidCancel(registerController : RegisterController)
    func registerControllerDidFinish(registerController : RegisterController, withEmail email: String)
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
        registerButton.layer.borderColor = UIColor.lightTextColor().CGColor

        emailField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        usernameField.addTarget(self, action: #selector(RegisterController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)

    }
    
    func textFieldDidChange(textField : UITextField!){
        if let username = usernameField.text where !username.isEmpty, let password = passwordField.text where !password.isEmpty, let email = emailField.text where !email.isEmpty{
            registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            registerButton.enabled = true
        }else{
            registerButton.setTitleColor(UIColor.lightTextColor(), forState: .Disabled)
            registerButton.enabled = false
        }
    }
    @IBAction func registerTapped(sender : UIButton!){
    
        guard let email = emailField?.text where !email.isEmpty, let password = passwordField?.text where !password.isEmpty, let username = usernameField?.text where !username.isEmpty else{
        return
        }
    
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { result, error in
            if error != nil{
            
                print("Error occured during registration \(error?.localizedDescription)")
            return
            }
            
            guard let uid = result!.uid as? String else{
            
                print("Invalid username for user \(email)")
                return
            }
            
            usernameRef.child(uid).setValue(username)
            profileRef.child(username).setValue(["username":username])
            let alertController = UIAlertController(title: "Registration Success!", message: "Your account was successfully created using email \(email)", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: {
            alertAction in
            //go to login controller and pass the email id for sign up
                self.delegate?.registerControllerDidFinish(self, withEmail: email)
            })
            alertController.addAction(alertAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }

    @IBAction func loginTapped(sender : UIButton!){
    delegate?.registerControllerDidCancel(self)
    }
    
}
