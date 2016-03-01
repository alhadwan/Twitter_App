//
//  TweetsDetailsViewController.swift
//  Twitter
//
//  Created by Ali hadwan on 2/12/16.
//  Copyright © 2016 Ali hadwan. All rights reserved.
//

import UIKit
import DOFavoriteButton
class DetailTweetsViewController: UIViewController {
    
    
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var TweetContentText: UILabel!
    @IBOutlet weak var DetailTimesTampLabel: UILabel!
    @IBOutlet weak var RetweetCountLabel: UILabel!
    @IBOutlet weak var LikeCountLabel: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var LikesButton: UIButton!
    @IBOutlet weak var ReplyButton: UIButton!
    
    
    
    var tweet: Tweet?
    var dateFormatter = NSDateFormatter()
    var isRetweetButton: Bool = false
    var islikeButton: Bool = false
    var tweetID: String = ""
    
    var LikeButton = DOFavoriteButton (frame: CGRectMake(-12, -12, 44, 45), image: UIImage(named: "like-action"))
    var TweeterButton =  DOFavoriteButton(frame: CGRectMake(-12, -12, 44, 44), image: UIImage(named: "retweet-action-pressed"))
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetID = tweet!.id
        print("tweetID now = \(tweetID)")
        TweetContentText!.text = tweet!.text
       userHandle.text = "\((tweet!.user!.name)!)"
        userHandle.text = "@\(tweet!.user!.screenname!)"
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        _ = dateFormatter.stringFromDate((tweet?.createdAt!)!)
        //DetailTimesTampLabel.text = "\(dateString)"
        if (tweet?.user?.profileImageUrl != nil){
            let imageUrl = tweet!.user!.profileImageUrl!
            Picture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No profile image found")
        }
        RetweetCountLabel.text = String(tweet!.retweetCount!)
        LikeCountLabel.text = String(tweet!.likeCount)
       userHandle.preferredMaxLayoutWidth = userHandle.frame.size.width
       Picture.layer.cornerRadius = 4
        Picture.clipsToBounds = true
//        self.RetweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: UIControlState.Normal)
//        self.LikesButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
        
        LikeButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
        LikeButton.imageColorOn = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
        LikeButton.circleColor = UIColor(red: 0.4431, green: 0.1647, blue: 0.4588, alpha: 1.0) /* #712a75 */
        LikeButton.duration = 2.0
        LikeButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.LikesButton!.addSubview(LikeButton)
        
        TweeterButton.addTarget(self, action: Selector("clicked:"), forControlEvents: .TouchUpInside)
        TweeterButton.imageColorOn = UIColor(red: 0.098, green: 0.8118, blue: 0.5255, alpha: 1.0) /* #19cf86 */
        TweeterButton.duration = 2.0
        TweeterButton.circleColor = UIColor(hue: 101/360, saturation: 87/100, brightness: 45/100, alpha: 1.0) /* #2e720e */
        TweeterButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
        self.RetweetButton!.addSubview(self.TweeterButton)
        self.RetweetCountLabel.textColor = UIColor.grayColor()
        self.LikeCountLabel.textColor = UIColor.grayColor()

        TweetContentText.sizeToFit()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    @IBAction func OnTweet(sender: AnyObject) {
//        if self.isRetweetButton {
//            self.RetweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: UIControlState.Normal)
//            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
//                
//                self.RetweetCountLabel.hidden = false
//                self.tweet!.retweetCount!--
//                self.isRetweetButton = false
//                self.RetweetCountLabel.textColor = UIColor.blackColor()
//                //self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
//                if self.RetweetCountLabel.text == "0"{
//                self.RetweetCountLabel.hidden = true
//                     self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
//                }
//                 // self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
//            })
//    } else {
//            if Int(tweetID) != nil {
//                TwitterClient.sharedInstance.retweet( Int(tweetID)!, params: nil, completion: {(error) -> () in
//                    self.RetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Selected)
//                    self.isRetweetButton = true
//                    self.tweet!.retweetCount!++
//                    self.RetweetCountLabel.textColor = UIColor(red: 0, green: 0.949, blue: 0.0314, alpha: 1.0)
//                    self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
//                    
//                })
//            } else {
//                print("tweetID is nil")
//            }
//        }
//}
    func clicked(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                self.isRetweetButton = false
                self.tweet!.retweetCount!--
                self.RetweetCountLabel.textColor = UIColor.grayColor()
                if self.RetweetCountLabel.text == "0"{
                    self.RetweetCountLabel.hidden = true
                }
                
                
                self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
            })
            
            
            
        }else {
            
            // select with animation
            sender.select()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet!.retweetCount!++
                
                
                self.RetweetCountLabel.hidden = false
                self.RetweetCountLabel.textColor = UIColor(hue: 155/360, saturation: 87/100, brightness: 81/100, alpha: 1.0) /* #19cf86 */
                if self.RetweetCountLabel.text == "0"{
                    self.RetweetCountLabel.hidden = false
                }
                
                self.RetweetCountLabel.text = "\(self.tweet!.retweetCount!)"
                
            })
            
            
            
        }
    }
    



//    @IBAction func onLike(sender: AnyObject) {
//       
//        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
//            if self.islikeButton {
//                self.LikeCountLabel.text = String(self.tweet!.likeCount!);
//                self.LikesButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
//                if self.LikeCountLabel.text! == "0" {
//                    self.LikeCountLabel.hidden = true
//                } else{
//                    self.LikeCountLabel.hidden = false
//                    self.tweet!.likeCount!--
//                    self.islikeButton = false
//                    self.LikeCountLabel.textColor = UIColor.blackColor()
//                    self.LikeCountLabel
//                        .text = "\(self.tweet!.likeCount!)"
//                }
//            }
//            else{
//            self.LikeCountLabel.hidden = false
//                self.islikeButton = true
//                self.tweet!.likeCount!++
//                self.LikeCountLabel.textColor = UIColor(red: 0.8471, green: 0.1608, blue: 0.2039, alpha: 1.0)
//                self.LikesButton.setImage(UIImage(named: "Like"), forState: UIControlState.Selected)
//
//                self.LikeCountLabel.text = "\(self.tweet!.likeCount!)"
//                
//            }
//            if self.LikeCountLabel.text! == "0" {
//                self.LikeCountLabel.hidden = true
//            }
//              self.LikeCountLabel.text = "\(self.tweet!.retweetCount!)"
//        })
//    }
    
    func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                
                self.islikeButton = false
                self.tweet!.likeCount!--
                self.LikeCountLabel.textColor = UIColor.grayColor()
                if self.LikeCountLabel.text == "0"{
                    self.LikeCountLabel.hidden = true
                }
                
                
                self.LikeCountLabel.text = "\(self.tweet!.likeCount!)"
            })
            
            
            
        }else {
            
            // select with animation
            sender.select()
            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet!.likeCount!++
                
                
                self.LikeCountLabel.hidden = false
                self.LikeCountLabel.textColor = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
                if self.LikeCountLabel.text == "0"{
                    self.LikeCountLabel.hidden = false
                }
                
                self.LikeCountLabel.text = "\(self.tweet!.likeCount!)"
                
            })
            
            
        }
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier) == "reply2Segue" {
            
            let user = User.currentUser
            let tweet = self.tweet
            let ReplyTweetViewController = segue.destinationViewController as! ReplyViewController
            ReplyTweetViewController.user = user
            ReplyTweetViewController.tweet = tweet
            
        } else if (segue.identifier) == "ProfileSegue" {
            let user = User.currentUser
            let tweet = self.tweet
            let ProfilePageViewController = segue.destinationViewController as! ProfileViewController
            ProfilePageViewController.user = user
            ProfilePageViewController.tweet = tweet
        }

    }
    
    
    
    
}
