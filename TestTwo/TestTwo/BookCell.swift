//
//  BookCell.swift
//  TestTwo
//
//  Created by Praneet Jain on 5/24/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var bookNameLabel: UILabel!
    
    var downloadTask : NSURLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureForBook(book : Book){
    
        bookNameLabel?.text = book.bookName
        thumbnailImageView?.image = UIImage(named: "Placeholder")
        
        if let url = NSURL(string: book.bookImageURL){
        
           downloadTask = thumbnailImageView?.cacheAndLoadImageFromURL(url)
        }
    
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
        bookNameLabel = nil
        thumbnailImageView = nil
        
    }
    deinit{
    downloadTask?.cancel()
    }
    
}
