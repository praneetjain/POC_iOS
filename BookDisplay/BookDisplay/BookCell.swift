//
//  ShopCellTableViewCell.swift
//  BookDisplay
//
//  Created by Praneet Jain on 5/30/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var labelBookImage: UIImageView!
    @IBOutlet weak var labelBookName: UILabel!
    
    var downloadTask : NSURLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCell(book : Book){
    
        labelBookName?.text = book.bookName
        
        let thumbnailURL = NSURL(string: book.bookSmallThumbnailURL)
        
        if let thumbnailURL = thumbnailURL{
        downloadTask = labelBookImage?.imageDownloadWithURL(thumbnailURL)
        }
        
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        downloadTask = nil
        labelBookName = nil
        labelBookImage = nil
    }
    
    deinit{
    downloadTask?.cancel()
    }
    
}
