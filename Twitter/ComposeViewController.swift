//
//  ComposeViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var ProfilePicture: UIImageView!

    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var userHandel: UILabel!
    @IBOutlet weak var TwitterButton: UIButton!
    @IBOutlet weak var ComposeLetterCountsLabel: UILabel!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var initialTextLabel: UILabel!
    
    
    var tweet: Tweet?
    var tweetMessage: String = ""
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if (user?.profileImageUrl != nil){
            let imageUrl = user!.profileImageUrl!
           ProfilePicture.setImageWithURL(NSURL(string: imageUrl)!)
        } else{
            print("No Picture")
        }
       UserName.text = "\((user?.name)!)"
        userHandel.text = "@\(user!.screenname!)"
        TextView.delegate = self
        ComposeLetterCountsLabel.text = "140"
        initialTextLabel.text = "Tweet Here ...."
        initialTextLabel.sizeToFit()
        TextView.addSubview(initialTextLabel)
        initialTextLabel.hidden = !TextView.text.isEmpty
        TextView.becomeFirstResponder()
        TwitterButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidChange(textView: UITextView) {
        initialTextLabel.hidden = !TextView.text.isEmpty
        if  0 < (141 - TextView.text!.characters.count) {
            TwitterButton.enabled = true
            ComposeLetterCountsLabel.text = "\(140 - TextView.text!.characters.count)"
        }
        else{
            TwitterButton.enabled = false
            ComposeLetterCountsLabel.text = "\(140 - TextView.text!.characters.count)"
        }
    }
    
    
    
    @IBAction func OnWriteTweet(sender: AnyObject) {
        tweetMessage = TextView.text
        let TweetMessage = tweetMessage.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
            TwitterClient.sharedInstance.ComposeTweet(TweetMessage!, params: nil, completion: { (error) -> () in
                print(error)
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
