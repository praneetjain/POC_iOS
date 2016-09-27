//
//  UIImageView+ImageDownload.swift
//  BookDisplay
//
//  Created by Praneet Jain on 5/30/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

extension UIImageView{

    func imageDownloadWithURL(_ url : URL) -> URLSessionDownloadTask?{
    
    let session = URLSession.shared
        
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self]url, response, error in
        
        
        if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data){
        
            DispatchQueue.main.async{
            
                if let strongSelf = self{
                    strongSelf.image = image
                }
            
            }
        
        
        }
        
        }) 
    downloadTask.resume()
    
    return downloadTask
    }



}
