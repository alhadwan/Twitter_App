//
//  MeViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//

import UIKit

class MyViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var FollowersCount: UILabel!
    @IBOutlet weak var TweetContentText: UILabel!
    
    var tweets: [Tweet]?
    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Picture.setImageWithURL(NSURL(string: (User.currentUser!.profileImageUrl)!)!)
        userName.text = "\((User.currentUser!.name)!)"
       userHandle.text = "@\(User.currentUser!.screenname!)"
       FollowersCount.text = "\(User.currentUser!.follower!)"
        FollowingCount.text = "\(User.currentUser!.following!)"
        TweetContentText.text = User.currentUser!.tagline!
        if (User.currentUser!.profileBannerURL != nil){
            let imageUrl = User.currentUser!.profileBannerURL!
            ProfilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Profile found")
        }
        
        
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            if (tweets != nil) {
                self.tweets = tweets
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
