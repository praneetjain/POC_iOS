//
//  FeedController.swift
//  SharePics
//
//  Created by Praneet Jain on 6/23/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class FeedController : UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 208
        postRef.observeEventType(.Value, withBlock: { snapshot in
            guard let posts = snapshot.value as? [String: [String : String]] else{
            print("No posts found")
            return
            }
          Post.feed?.removeAll()
            for (postID, post) in posts{
                let newPost = Post.initWithPostID(postID, postDict: post)
                Post.feed?.append(newPost!)
            }
            Post.feed = Post.feed?.reverse()//recent at top
            self.tableView.reloadData()// refresh the feed with new data
            }, withCancelBlock: {error in
                print(error.localizedDescription)
            }
        )
    }
    
    func showOptions(sender: UIButton!) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.tableView)
        guard let indexPath = tableView.indexPathForRowAtPoint(buttonPosition) else {
            return
        }
        
        let post = Post.feed![postIndex(indexPath.section)]
        if post.creator == Profile.currentUser!.username {
            Post.feed!.removeAtIndex(postIndex(indexPath.section))
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (alert: UIAlertAction!) -> Void in
                let postID = post.postID!
                postRef.child(postID).removeValueWithCompletionBlock({ error, ref in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    print("Deleted post: \(ref.description())")
                })
            })
            actionSheet.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()  //Refreshes our feed
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let feed = Post.feed{
            return feed.count
        }
        else{
            return 0
        }
    }


    func postIndex(cellIndex : Int) -> Int{
    
        return tableView.numberOfSections - cellIndex - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = Post.feed![postIndex(indexPath.section)]
     
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
     
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48 //the default height of this cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = Post.feed![postIndex(section)]
        let postHeaderCell = tableView.dequeueReusableCellWithIdentifier("PostHeaderCell") as? PostHeaderCell
        if post.creator == Profile.currentUser?.username{
            postHeaderCell?.profilePicture.image = Profile.currentUser?.picture
        }
        else{
        //set to creators' image
        }
        postHeaderCell?.usernameButton.setTitle(post.creator, forState: .Normal)
        
        return postHeaderCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = Post.feed![postIndex(indexPath.section)]
        
            let aspectRatio = post.image.size.height / post.image.size.width
            return tableView.frame.size.width * aspectRatio + 80 // height accounting for button and caption
            
    }

    @IBAction func viewUsersProfile(sender : UIButton!){
    let mainSB = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let profileVC = mainSB.instantiateViewControllerWithIdentifier("Profile") as! ProfileController
        profileVC.profileUsername = sender.titleForState(.Normal)
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}
