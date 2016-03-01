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
    

    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var TweetContentText: UILabel!
    @IBOutlet weak var TimesCreater: UILabel!
    @IBOutlet weak var RetweetButton: UIButton!
    @IBOutlet weak var ReplyButton: UIButton!
    @IBOutlet weak var LikeButton: UIButton!
    @IBOutlet weak var RetweetLabel: UILabel!
    @IBOutlet weak var LikesLabel: UILabel!
    
    
    
    
    var view: UIView!
    var tweetID: String = ""
    var  isRetweetButton: Bool = false
    var islikeButton: Bool = false
    
   // var LikesButton = DOFavoriteButton (frame: CGRectMake(-20, -20, 44, 45), image: UIImage(named: "like-action"))
    var TweeterButton =  DOFavoriteButton(frame: CGRectMake(-10, -10, 44, 44), image: UIImage(named: "retweet-action-pressed"))
    
    

    
    var tweet: Tweet! {
        didSet {
        TweetContentText.text = tweet.text
        userName.text = "\((tweet.user?.name)!)"
        userHandle.text = "@\(tweet.user!.screenname!)"
        if (tweet.user?.profileImageUrl != nil){
            let imageUrl = tweet.user?.profileImageUrl!
            Picture.setImageWithURL(NSURL(string: imageUrl!)!)
        } else{
            print("No Picture")
        }
//            LikesButton.addTarget(self, action: Selector("tapped:"), forControlEvents: .TouchUpInside)
//            LikesButton.imageColorOn = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
//            LikesButton.circleColor = UIColor(red: 0.4431, green: 0.1647, blue: 0.4588, alpha: 1.0) /* #712a75 */
//            LikesButton.duration = 2.0
//            LikesButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
//            self.LikesButton.addSubview(self.LikeButton!)
            
            TweeterButton.addTarget(self, action: Selector("clicked:"), forControlEvents: .TouchUpInside)
            TweeterButton.imageColorOn = UIColor(red: 0.098, green: 0.8118, blue: 0.5255, alpha: 1.0) /* #19cf86 */
            TweeterButton.duration = 2.0
            TweeterButton.circleColor = UIColor(hue: 101/360, saturation: 87/100, brightness: 45/100, alpha: 1.0) /* #2e720e */
            TweeterButton.lineColor = UIColor(red: 0.3333, green: 0.6745, blue: 0.9333, alpha: 1.0) /* #55acee */
            self.RetweetButton!.addSubview(self.TweeterButton)
            self.RetweetLabel.textColor = UIColor.grayColor()
            self.LikesLabel.textColor = UIColor.grayColor()

            
        RetweetLabel.text = String(tweet.retweetCount!)
        LikesLabel.text = String(tweet.likeCount!)
        tweetID = tweet.id
       RetweetLabel.text! == "0" ? (RetweetLabel.hidden = true) : (RetweetLabel.hidden = false)
        LikesLabel.text! == "0" ? (LikesLabel.hidden = true) : (LikesLabel.hidden = false)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       userName.preferredMaxLayoutWidth = userName.frame.size.width
        Picture.layer.cornerRadius = 4
        Picture.clipsToBounds = true
        //self.RetweetButton.setImage(UIImage(named: "Retweet-Green"), forState: UIControlState.Selected)
       // self.LikeButton.setImage(UIImage(named: "Like-Red"), forState: UIControlState.Selected)
        TweetContentText.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userName.preferredMaxLayoutWidth = userName.frame.size.width
    }
    
    
    
    func clicked(sender: DOFavoriteButton) {
        if sender.selected {
            sender.deselect()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
                self.isRetweetButton = false
                self.tweet!.retweetCount!--
                self.RetweetLabel.textColor = UIColor.grayColor()
                if self.RetweetLabel.text == "0"{
                    self.RetweetLabel.hidden = true
                }
                
                
                self.RetweetLabel.text = "\(self.tweet!.retweetCount!)"
            })
            
            
            
        }else {
            
            // select with animation
            sender.select()
            TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
                
                
                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
                self.islikeButton = true
                
                self.tweet!.retweetCount!++
                
                
                self.RetweetLabel.hidden = false
                self.RetweetLabel.textColor = UIColor(hue: 155/360, saturation: 87/100, brightness: 81/100, alpha: 1.0) /* #19cf86 */
                if self.RetweetLabel.text == "0"{
                    self.RetweetLabel.hidden = false
                }
                
                self.RetweetLabel.text = "\(self.tweet!.retweetCount!)"
                
            })
            
            
            
        }
    }
    
    
//    func tapped(sender: DOFavoriteButton) {
//        if sender.selected {
//            sender.deselect()
//            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
//                
//                //self.Likes_CountLabel.text = String(self.tweet.likeCount!);self.LikeButton.setImage(UIImage(named: "like-action"), forState: UIControlState.Normal)
//                
//                self.islikeButton = false
//                self.tweet!.likeCount!--
//                self.LikesLabel.textColor = UIColor.grayColor()
//                if self.LikesLabel.text == "0"{
//                    self.LikesLabel.hidden = true
//                }
//                
//                
//                self.LikesLabel.text = "\(self.tweet!.likeCount!)"
//            })
//            
//            
//            
//        }else {
//            
//            // select with animation
//            sender.select()
//            TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
//                
//                
//                // self.LikeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
//                self.islikeButton = true
//                
//                self.tweet!.likeCount!++
//                
//                
//                self.LikesLabel.hidden = false
//                self.LikesLabel.textColor = UIColor(red: 0.9098, green: 0.2314, blue: 0.2078, alpha: 1.0) /* #e83b35 */
//                if self.LikesLabel.text == "0"{
//                    self.LikesLabel.hidden = false
//                }
//                
//                self.LikesLabel.text = "\(self.tweet!.likeCount!)"
//                
//            })
//            
//            
//        }
//    }
//    

    
    
//    @IBAction func onTweet(sender: AnyObject) {
//        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
//            
//            if self.isRetweetButton {
//                self.RetweetLabel.text = String(self.tweet.retweetCount!)
//                self.RetweetButton.setImage(UIImage(named: "retweet-action-pressed"), forState: UIControlState.Normal)
//                self.isRetweetButton = false
//                self.tweet.retweetCount!--
//                self.RetweetLabel.textColor = UIColor.grayColor()
//                if self.RetweetLabel.text == "0"{
//                    self.RetweetLabel.hidden = true
//                }
//            } else{
//                self.RetweetButton.setImage(UIImage(named: "Retweet"), forState: UIControlState.Normal)
//                
//                self.RetweetLabel.textColor = UIColor(red: 0.0157, green: 0.9176, blue:0.5137, alpha: 1.0)
//                self.isRetweetButton = true
//                self.tweet.retweetCount!++
//                if self.RetweetLabel.text == "0"{
//                    self.RetweetLabel.hidden = false
//                }
//                
//                
//            }
//            self.RetweetLabel.text = "\(self.tweet.retweetCount!)"
//        })    }
//    
//    
    
    @IBAction func onLike(sender: AnyObject) {
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: { (error) ->() in
            if self.islikeButton {
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
        })
    }
    
     override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
