//
//  FeedModel.swift
//  SharePics
//
//  Created by Praneet Jain on 6/22/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class Post{

    let creator : String
    let timestamp : NSDate
    let image : UIImage
    let caption : String?
    let postID : String?
    static var feed:Array<Post>?

    init(postID: String?, creator: String, image: UIImage, caption: String?){
    
        self.postID = postID
        self.creator = creator
        self.image = image
        self.caption = caption
        timestamp = NSDate()
    }
    
    static func initWithPostID(postID: String, postDict: [String: String]) -> Post? {
        guard let creator = postDict["creator"], let base64String = postDict["image"] else {
            // Conditions failed...
            print("Invalid Post Dictionary!")
            return nil
        }
        let caption = postDict["caption"]
        let image = UIImage.imageWithBase64String(base64String)
        return Post(postID: postID, creator: creator, image: image, caption: caption)
    }
    
    func dictValue() -> [String : String]{
        var postDict = [String : String]()
        postDict["creator"] = creator
        postDict["image"] = image.base64String()
        if let realCaption = caption{
            postDict["caption"] = realCaption
        }
     return postDict
    }
    

}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    
    
}

class PostHeaderCell : UITableViewCell{

    @IBOutlet weak var profilePicture : UIImageView!
    @IBOutlet weak var usernameButton : UIButton!
}