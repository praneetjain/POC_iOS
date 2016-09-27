//
//  ProfileModel.swift
//  SharePics
//
//  Created by Praneet Jain on 6/22/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class Profile{


    let username: String
    var followers : Array<String>
    var following : Array<String>
    var posts : Array<String>
    var picture : UIImage?
    static var currentUser : Profile?

    init(username:String, followers:Array<String>, following:Array<String>, posts:Array<String>, picture:UIImage?){
    
        self.username = username
        self.followers = followers
        self.following = following
        self.posts = posts
        self.picture = picture
        
    }
    
    static func initWithUsername(_ username: String, profileDict:[String : AnyObject]) -> Profile?{
    
    let profile = Profile.createUser(username)
        if let followers = profileDict["followers"] as? [String]{
        profile.followers = followers
        }
    
        if let following = profileDict["following"] as? [String]{
        profile.following = following
        }
        
        if let posts = profileDict["posts"] as? [String]{
        profile.posts = posts
        }
        
        if let pictureString = profileDict["picture"] as? String{
        profile.picture = UIImage.imageWithBase64String(pictureString)
        }
        return profile
    }
    
    
    static func createUser(_ username : String!) -> Profile{
    
    return Profile(username: username, followers: Array<String>(), following: [String](), posts: [String](), picture: nil)
    }
    
    func dictValue() -> [String : AnyObject]{
        var profileDict = [String : AnyObject]()
        profileDict["username"] = username as AnyObject?
        profileDict["followers"] = followers as AnyObject?
        profileDict["following"] = following as AnyObject?
        profileDict["posts"] = posts as AnyObject?
        
        if let profPicture = picture{
        profileDict["picture"] = profPicture.base64String() as AnyObject?
        }
        return profileDict
    }

    func sync(){
    profileRef.child(username).setValue(dictValue())
    
    }
}
