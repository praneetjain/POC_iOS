//
//  Extension.swift
//  SharePics
//
//  Created by Praneet Jain on 6/23/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

extension UIColor{

    static func rawColor(red rawRed : CGFloat, green rawGreen : CGFloat, blue rawBlue : CGFloat, alpha : CGFloat) -> UIColor{
    
        return UIColor(red: rawRed/255.0, green: rawGreen/255.0, blue: rawBlue/255.0, alpha: alpha)
    }
}

extension UIImage{

    func base64String() -> String{
    let imageData = UIImagePNGRepresentation(self)
    let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
    return base64String
    }

    static func imageWithBase64String(_ base64String: String) -> UIImage{
    
        let decodedData = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let postImage = UIImage(data: decodedData)
        return postImage!
    }
    
    
    static func initWithPostID(_ postID : String, postDict : [String : String]) -> Post?{
    
    guard let creator = postDict["creator"], let base64String = postDict["image"] else{
    //conditions failed...
    print("Invalid Post Dictionary!")
    return nil
    }
    
    let caption = postDict["caption"]
    let image = UIImage.imageWithBase64String(base64String)
    return Post(postID : postID, creator: creator, image: image, caption: caption)
    }
        
}
