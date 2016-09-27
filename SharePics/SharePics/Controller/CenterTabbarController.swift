//
//  CameraTabbarController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/23/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class CenterTabbarController : UITabBarController{


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.white
        tabBar.barTintColor = UIColor(white: 0.25, alpha: 1.0)
        tabBar.isTranslucent = false
        
        for(index, viewController) in self.viewControllers!.enumerated(){
        viewController.title = nil
            viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
            if index == self.viewControllers!.count/2{
            viewController.tabBarItem.isEnabled = true
            }
        }
        
        let cameraButton = UIButton(type: .custom)
        let cameraImage = UIImage(named: "camera")
        
        let numTabs = self.viewControllers!.count

        let screenWidth = UIScreen.main.bounds.width
        cameraButton.frame = CGRect(x: 0, y: 0, width: screenWidth/CGFloat(numTabs), height: self.tabBar.frame.size.height)
        
        cameraButton.setImage(cameraImage, for: UIControlState())
        
        cameraButton.tintColor = UIColor.white
        cameraButton.backgroundColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
        cameraButton.center = self.tabBar.center
        cameraButton.addTarget(self, action: #selector(CenterTabbarController.showCamera), for: .touchUpInside)
        self.view.addSubview(cameraButton)
    }
    
    func showCamera(_ sender : UIButton!){
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let cameraPicker = mainStoryboard.instantiateViewController(withIdentifier: "CameraPopup")
        
        self.present(cameraPicker, animated: true, completion: nil)
    }

}
