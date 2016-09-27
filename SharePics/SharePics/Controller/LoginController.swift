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
        loginButton.layer.borderColor = UIColor.lightTextColor().CGColor
        
        usernameField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: #selector(LoginController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
    }
    
    
    func textFieldDidChange(textField : UITextField!){
        if let username = usernameField.text where !username.isEmpty, let password = passwordField.text where !password.isEmpty{
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            loginButton.enabled = true
        }else{
            loginButton.setTitleColor(UIColor.lightTextColor(), forState: .Disabled)
            loginButton.enabled = false
        }
    }
    func login(email: String, password: String){
    
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { response, error in
            
            if error != nil{
            print(error?.localizedDescription)
                self.activityIndicator.stopAnimating()
                return
            }
            
            let uid = response?.uid
            usernameRef.child(uid!).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                guard let username = snapshot.value as? String else{
                print("No user found for \(email)")
                self.activityIndicator.stopAnimating()
                return
                }
                
                profileRef.child(username).observeSingleEventOfType(.Value, withBlock: {
                snapshot in
                    self.activityIndicator?.stopAnimating()
                    
                    guard let profile = snapshot.value as? [String: AnyObject] else{
                    print("No profile found for user")
                        return
                    }
                Profile.currentUser = Profile.initWithUsername(username, profileDict: profile)
                    let mainSB = UIStoryboard(name:"Main", bundle: NSBundle.mainBundle())
                    let rootController = mainSB.instantiateViewControllerWithIdentifier("Tabs")
                    self.presentViewController(rootController, animated: true, completion: nil)
                })
            })
            
        })
        
        
          }
    
    @IBAction func loginTapped(sender : UIButton!){
        guard let username = usernameField?.text where !username.isEmpty, let password = passwordField?.text where !password.isEmpty else{
            return
        }
        activityIndicator?.startAnimating()
        login(username, password: password)
    
    }
    
    @IBAction func signupTapped(sender : UIButton!){
    
        let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let registerController = mainSB.instantiateViewControllerWithIdentifier("Register") as! RegisterController
        registerController.delegate = self
        presentViewController(registerController, animated: true, completion: nil)
    }
}

extension LoginController : RegisterControllerDelegate{

    func registerControllerDidCancel(registerController: RegisterController) {
        registerController.dismissViewControllerAnimated(true, completion: nil)
    }
    func registerControllerDidFinish(registerController: RegisterController, withEmail email: String) {
        usernameField.text = email
        registerController.dismissViewControllerAnimated(true, completion: nil)
    }
}
