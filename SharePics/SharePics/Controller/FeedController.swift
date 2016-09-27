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
        postRef.observe(.value, with: { snapshot in
            guard let posts = snapshot.value as? [String: [String : String]] else{
            print("No posts found")
            return
            }
          Post.feed?.removeAll()
            for (postID, post) in posts{
                let newPost = Post.initWithPostID(postID, postDict: post)
                Post.feed?.append(newPost!)
            }
            Post.feed = Post.feed?.reversed()//recent at top
            self.tableView.reloadData()// refresh the feed with new data
            }, withCancel: {error in
                print(error.localizedDescription)
            }
        )
    }
    
    func showOptions(_ sender: UIButton!) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        let post = Post.feed![postIndex((indexPath as NSIndexPath).section)]
        if post.creator == Profile.currentUser!.username {
            Post.feed!.remove(at: postIndex((indexPath as NSIndexPath).section))
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
                let postID = post.postID!
                postRef.child(postID).removeValue(completionBlock: { error, ref in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    print("Deleted post: \(ref.description())")
                })
            })
            actionSheet.addAction(deleteAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()  //Refreshes our feed
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let feed = Post.feed{
            return feed.count
        }
        else{
            return 0
        }
    }


    func postIndex(_ cellIndex : Int) -> Int{
    
        return tableView.numberOfSections - cellIndex - 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = Post.feed![postIndex((indexPath as NSIndexPath).section)]
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48 //the default height of this cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let post = Post.feed![postIndex(section)]
        let postHeaderCell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as? PostHeaderCell
        if post.creator == Profile.currentUser?.username{
            postHeaderCell?.profilePicture.image = Profile.currentUser?.picture
        }
        else{
        //set to creators' image
        }
        postHeaderCell?.usernameButton.setTitle(post.creator, for: UIControlState())
        
        return postHeaderCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let post = Post.feed![postIndex((indexPath as NSIndexPath).section)]
        
            let aspectRatio = post.image.size.height / post.image.size.width
            return tableView.frame.size.width * aspectRatio + 80 // height accounting for button and caption
            
    }

    @IBAction func viewUsersProfile(_ sender : UIButton!){
    let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        let profileVC = mainSB.instantiateViewController(withIdentifier: "Profile") as! ProfileController
        profileVC.profileUsername = sender.title(for: UIControlState())
        let barButton = UIBarButtonItem()
        barButton.title = "Back"
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}
