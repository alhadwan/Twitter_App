//
//  ViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//


import UIKit
import AFNetworking
import BDBOAuth1Manager



class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        // 1
//        let nav = self.navigationController?.navigationBar
//        // 2
//        nav?.barStyle = UIBarStyle.Black
//        nav?.tintColor = UIColor.yellowColor()
//        // 3
////        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
////        imageView.contentMode = .ScaleAspectFit
////        // 4
////        let image = UIImage(named: "Apple_Swift_Logo")
////        imageView.image = image
////        // 5
////        navigationItem.titleView = imageView
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {

        
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle error
            }
        }
        
    }

}

