//
//  UIImageView+ImageDownload.swift
//  BookDisplay
//
//  Created by Praneet Jain on 5/30/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

extension UIImageView{

    func imageDownloadWithURL(url : NSURL) -> NSURLSessionDownloadTask?{
    
    let session = NSURLSession.sharedSession()
        
    let downloadTask = session.downloadTaskWithURL(url) { [weak self]url, response, error in
        
        
        if error == nil, let url = url, data = NSData(contentsOfURL: url), image = UIImage(data: data){
        
            dispatch_async(dispatch_get_main_queue()){
            
                if let strongSelf = self{
                    strongSelf.image = image
                }
            
            }
        
        
        }
        
        }
    downloadTask.resume()
    
    return downloadTask
    }



}