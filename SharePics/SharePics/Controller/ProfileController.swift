//
//  ProfileController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/22/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

enum ActionButtonState : String{

case CurrentUser = "Edit Profile"
case NotFollowing = "+ Follow"
case Following = "✓ Following"
    
}

class ProfileController : UIViewController{

    @IBOutlet weak var profilePic : UIImageView!
    @IBOutlet weak var postsLabel : UILabel!
    @IBOutlet weak var followersLabel : UILabel!
    @IBOutlet weak var followingLabel : UILabel!
    @IBOutlet weak var actionButton : UIButton!
    @IBOutlet weak var logoutButton : UIBarButtonItem!
    var actionButtonState : ActionButtonState = .CurrentUser{
    
        willSet(newState){
        
            switch newState {
            case .CurrentUser:
                actionButton.backgroundColor = UIColor.rawColor(red: 228, green: 228, blue: 228, alpha: 1.0)
                actionButton.layer.borderWidth = 1
            case .NotFollowing:
                actionButton.backgroundColor = UIColor.white
                actionButton.layer.borderColor = UIColor.rawColor(red: 18, green: 86, blue: 136, alpha: 1.0).cgColor
                actionButton.layer.borderWidth = 1
            case .Following:
                actionButton.backgroundColor = UIColor.rawColor(red: 111, green: 187, blue: 82, alpha: 1.0)
                actionButton.layer.borderWidth = 0
            }
        actionButton.setTitle(newState.rawValue, for: UIControlState())
        }
    
    }
    
    var profileUsername = Profile.currentUser?.username //show current user by default
    var userProfile : Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 3
        profilePic.layer.cornerRadius = 40 //Height and Width in storyboard is 80.
        profilePic.layer.masksToBounds = true //Required for UIImageView to hide clip portion
        
        guard let username = profileUsername else{
            print("No username for profileController")
            return
        }
        userProfile = Profile.currentUser

        if username == Profile.currentUser?.username{
        
            //update profile ui
            updateProfile()
        }
        else{
        logoutButton.isEnabled = false
        logoutButton.tintColor = UIColor.clear
        }
        profileRef.child(username).observeSingleEvent(of: .value, with: { snapshot in
         
            guard let profile = snapshot.value as? [String : AnyObject] else{
            return
            }
            self.userProfile = Profile.initWithUsername(username, profileDict: profile)
            
            if username != Profile.currentUser?.username{
                if self.userProfile!.followers.contains(Profile.currentUser!.username){
                    //we are not following them
                    self.actionButtonState = .Following
                }
                else{
                //we are following them
                    self.actionButtonState = .NotFollowing
                }
            }
            self.updateProfile()
            }, withCancel: {
        error in
                print("Error loading \(self.profileUsername)'s profile \(error.localizedDescription)")
                
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        navigationItem.title = profileUsername
    }
    
    func updateProfile(){
    postsLabel.text = "\(userProfile?.posts.count)"
        followersLabel.text = "\(userProfile?.followers.count)"
        followingLabel.text = "\(userProfile?.following.count)"
        if let profPic = userProfile?.picture{
        self.profilePic.image = profPic
        }
        
        
    }
    
    @IBAction func editProfile(_ sender : AnyObject){
    print("User wants to edit their profile")
        switch actionButtonState {
        case .CurrentUser:
            let actionSheet = UIAlertController(title: "Edit Profile", message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let photoAction = UIAlertAction(title: "Change Photo", style: .default, handler: { action in
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
               
            })
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true, completion: nil)
        case .NotFollowing:
            actionButtonState = .Following
            Profile.currentUser?.following.append(userProfile!.username)
            userProfile?.followers.append(Profile.currentUser!.username)
            userProfile?.sync()
            Profile.currentUser?.sync()

        case .Following:
            actionButtonState = .NotFollowing
            if let index = Profile.currentUser?.following.index(of: profileUsername!){
            Profile.currentUser?.following.remove(at: index)
            
            }
            if let index = Profile.currentUser?.followers.index(of: profileUsername!){
            Profile.currentUser?.followers.remove(at: index)
            }
userProfile?.sync()
            Profile.currentUser?.sync()
        }
    }
    @IBAction func logoutTapped(_ sender : UIBarButtonItem!){
    postRef.removeAllObservers()
        tabBarController?.dismiss(animated: true, completion: nil)
    }
}

extension ProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userProfile?.picture = info[UIImagePickerControllerEditedImage] as? UIImage
        profilePic.image = userProfile?.picture
        userProfile?.sync()
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

