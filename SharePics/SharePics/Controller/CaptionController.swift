//
//  CaptionController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/23/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

protocol CaptionControllerDelegate : class {
    
    func captionController(_ controller : CaptionController, didFinishWithCaption caption: String)
}

class CaptionController : UIViewController{


    @IBOutlet weak var captionTextView : UITextView!
    @IBOutlet weak var imagePreview : UIImageView!
    var selectedImage : UIImage!
    weak var delegate : CaptionControllerDelegate?

    override func viewDidLoad() {
        imagePreview.image = selectedImage
    }
    
    @IBAction func tap(_ sender : UITapGestureRecognizer!){
    captionTextView.resignFirstResponder()
    }
    
    @IBAction func submitPressed(_ sender : UIButton!){
        if let captionDelegate = self.delegate{
            captionDelegate.captionController(self, didFinishWithCaption: captionTextView.text)
        }
    }
    
    @IBAction func backPressed(_ sender : UIButton!){
    self.dismiss(animated: true, completion: nil)
    }
}
