//
//  TweetsTableViewCell.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//


import UIKit
import DOFavoriteButton

class TweetsTableViewCell: UITableViewCell {
    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
   
    @IBOutlet weak var TweetContentText: UILabel!
    @IBOutlet weak var TimesCreater: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var RetweetLabel: UILabel!
    @IBOutlet weak var LikesLabel: UILabel!
   var button = DOFavoriteButton(frame: CGRectMake(0, 0, 44, 44), image: UIImage(named: "star"))
    var  isRetweetButton: Bool = false
    var islikeButton: Bool = false
    var tweetID: String = ""
    
    
    var tweet: Tweet! {
        didSet {
        TweetContentText.text = tweet.text
        userName.text = "\((tweet.user?.name)!)"
        userHandle.text = "@\(tweet.user!.screenname!)"
        if (tweet.user?.profileImageUrl != nil){
            let imageUrl = tweet.user?.profileImageUrl!
            profileImage.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            print("No profile image found")
        }
        RetweetLabel.text = String(tweet.retweetCount!)
        LikesLabel.text = String(tweet.likeCount!)
        tweetID = tweet.id
     RetweetLabel.text! == "0" ? (RetweetLabel.hidden = true) : (RetweetLabel.hidden = false)
        LikesLabel.text! == "0" ? (LikesLabel.hidden = true) : (LikesLabel.hidden = false)
            self.LikesLabel.textColor = UIColor.grayColor()
            self.RetweetLabel.textColor = UIColor.grayColor()
            

         }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        profileImage.layer.cornerRadius = 4
        profileImage.clipsToBounds = true
        userName.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
        //TweetContentText.preferredMaxLayoutWidth = TweetContentText.frame.size.height
    }
    
    @IBAction func OnTweet(sender: AnyObject) {
        
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
            if self.isRetweetButton {
        self.RetweetLabel.text = String(self.tweet.retweetCount!)
        self.RetweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: UIControlState.Normal)
            self.isRetweetButton = false
            self.tweet.retweetCount!--
           self.RetweetLabel.textColor = UIColor.grayColor()
                if self.RetweetLabel.text == "0" {
                    self.RetweetLabel.hidden = true
                }

        } else{
            self.RetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
        
            self.RetweetLabel.textColor = UIColor(red: 0.0157, green: 0.9176, blue:0.5137, alpha: 1.0)
            self.isRetweetButton = true
            self.tweet.retweetCount!++
   
        if self.RetweetLabel.text == "0"{
            self.RetweetLabel.hidden = false
        }
                }
                self.RetweetLabel.text = "\(self.tweet.retweetCount!)"
        })
    }
    
    @IBAction func OnLike(sender: AnyObject) {
        //TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
         if islikeButton {
      self.LikesLabel.text = String(self.tweet.likeCount!);
            self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
            self.islikeButton = false
            self.tweet.likeCount!--
            self.LikesLabel.textColor = UIColor.grayColor()
            if self.LikesLabel.text == "0" {
                self.LikesLabel.hidden = true
            }

            } else{
            self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
            self.islikeButton = true
            self.tweet.likeCount!++
            self.LikesLabel.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0) /* #d82934 */
            if self.LikesLabel.text == "0" {
                self.LikesLabel.hidden = false
            }

          }
                self.LikesLabel.text = "\(self.tweet.likeCount!)"
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
}
