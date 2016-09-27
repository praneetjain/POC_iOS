//
//  CameraController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/23/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class CameraController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CaptionControllerDelegate{

    @IBOutlet weak var selectedImageView : UIImageView!
    @IBOutlet weak var sourceLabel : UILabel!

    var selectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLabel.text = "No image selected"
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selectedImageView.image = selectedImage
        
        if picker.sourceType == .Camera {
            self.sourceLabel.text = "PHOTO"
        }
        else if picker.sourceType == .PhotoLibrary{
        self.sourceLabel.text = "LIBRARY"
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let controller = segue.destinationViewController as! CaptionController
        controller.selectedImage = selectedImage
        controller.delegate = self
        
    }
    
    func captionController(controller: CaptionController, didFinishWithCaption caption: String) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        guard let postImage = selectedImage else{
        
            print("No image selected")
            return
        }
        
        let newPost = Post.init(postID: nil, creator: Profile.currentUser!.username, image: selectedImage!, caption: caption)
        
        let uniquePostRef = postRef.childByAutoId() //create unique time-sensitive post id
        uniquePostRef.setValue(newPost.dictValue())
                
        let tabbarController = self.presentingViewController as? UITabBarController
        tabbarController?.selectedIndex = 0 //Goes back to feed tab
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func takePhoto(sender : UIButton!){
    
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .Camera
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    
    }
    
    @IBAction func selectPhoto(sender : UIButton!){
    let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .PhotoLibrary
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    
    }
    
    @IBAction func dismissPhotoPicker(sender : UIButton!){
    self.dismissViewControllerAnimated(true, completion: nil)
    }
}
