//
//  UserProfileViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//


import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var FollowersCount: UILabel!
    @IBOutlet weak var TweetContentText: UILabel!
    
    
    var tweet: Tweet?
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Picture.setImageWithURL(NSURL(string: (tweet!.user?.profileImageUrl)!)!)
        userName.text = "\((tweet!.user?.name)!)"
        userHandle.text = "@\(tweet!.user!.screenname!)"
        FollowersCount.text = "\(tweet!.user!.follower!)"
        FollowingCount.text = "\(tweet!.user!.following!)"
        TweetContentText.text = tweet!.user!.tagline!
        if (tweet!.user!.profileBannerURL != nil){
            let imageUrl = tweet!.user!.profileBannerURL!
            ProfilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
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
