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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.selectedImageView.image = selectedImage
        
        if picker.sourceType == .camera {
            self.sourceLabel.text = "PHOTO"
        }
        else if picker.sourceType == .photoLibrary{
        self.sourceLabel.text = "LIBRARY"
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let controller = segue.destination as! CaptionController
        controller.selectedImage = selectedImage
        controller.delegate = self
        
    }
    
    func captionController(_ controller: CaptionController, didFinishWithCaption caption: String) {
        controller.dismiss(animated: true, completion: nil)
        guard (selectedImage != nil) else{
        
            print("No image selected")
            return
        }
        
        let newPost = Post.init(postID: nil, creator: Profile.currentUser!.username, image: selectedImage!, caption: caption)
        
        let uniquePostRef = postRef.childByAutoId() //create unique time-sensitive post id
        uniquePostRef.setValue(newPost.dictValue())
                
        let tabbarController = self.presentingViewController as? UITabBarController
        tabbarController?.selectedIndex = 0 //Goes back to feed tab
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(_ sender : UIButton!){
    
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    
    }
    
    @IBAction func selectPhoto(_ sender : UIButton!){
    let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    
    }
    
    @IBAction func dismissPhotoPicker(_ sender : UIButton!){
    self.dismiss(animated: true, completion: nil)
    }
}
