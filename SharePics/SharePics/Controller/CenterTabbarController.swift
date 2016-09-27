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
        
        tabBar.tintColor = UIColor.whiteColor()
        tabBar.barTintColor = UIColor(white: 0.25, alpha: 1.0)
        tabBar.translucent = false
        
        for(index, viewController) in self.viewControllers!.enumerate(){
        viewController.title = nil
            viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
            if index == self.viewControllers!.count/2{
            viewController.tabBarItem.enabled = true
            }
        }
        
        let cameraButton = UIButton(type: .Custom)
        let cameraImage = UIImage(named: "camera")
        
        let numTabs = self.viewControllers!.count

        let screenWidth = UIScreen.mainScreen().bounds.width
        cameraButton.frame = CGRectMake(0, 0, screenWidth/CGFloat(numTabs), self.tabBar.frame.size.height)
        
        cameraButton.setImage(cameraImage, forState: .Normal)
        
        cameraButton.tintColor = UIColor.whiteColor()
        cameraButton.backgroundColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1.0)
        cameraButton.center = self.tabBar.center
        cameraButton.addTarget(self, action: #selector(CenterTabbarController.showCamera), forControlEvents: .TouchUpInside)
        self.view.addSubview(cameraButton)
    }
    
    func showCamera(sender : UIButton!){
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let cameraPicker = mainStoryboard.instantiateViewControllerWithIdentifier("CameraPopup")
        
        self.presentViewController(cameraPicker, animated: true, completion: nil)
    }

}
