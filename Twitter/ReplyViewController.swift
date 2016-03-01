//
//  ReplyViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var CountsLabel: UILabel!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var TweetsButton: UIButton!

    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!
 //   var handleLabelText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
           Picture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
        userName.text = "\((user?.name)!)"
        userHandle.text = "@\(user!.screenname!)"
        TextView.delegate = self
        CountsLabel.text = "140"
        TextView.text = "@\(tweet!.user!.screenname!)\n"
        TextView.becomeFirstResponder()
       TweetsButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        if  0 < (141 - TextView.text!.characters.count) {
            TweetsButton.enabled = true
            CountsLabel.text = "\(140 - TextView.text!.characters.count)"
        }
        else{
            TweetsButton.enabled = false
            CountsLabel.text = "\(140 - TextView.text!.characters.count)"
        }
    }
    
    @IBAction func OnReplyTweet(sender: AnyObject) {
        tweetMessage = TextView.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        TwitterClient.sharedInstance.ReplyToTweet(TweetMessage!, statusID: Int(tweet!.id)!, params: nil, completion: { (error) -> () in
        })
        navigationController?.popViewControllerAnimated(true)
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
