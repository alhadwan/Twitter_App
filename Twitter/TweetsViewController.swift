//
//  TweetsViewController.swift
//  Twitter
//
// Created by Ali Hadwan on 2/9/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//


import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    //var loadingMoreView:InfiniteScrollActivityView?
    var isMoreDataLoading = false
    var loadMoreOffset = 20
    
    @IBOutlet weak var tableView: UITableView!
    var refrechController: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networker_Request()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
        
        //tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refresher_contorl()
//            
//            self.tableView.infiniteScrollIndicatorStyle = .Gray
//            self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
//                let tableView = scrollView as! UITableView
//                
//                tableView.reloadData()
//                
//            }
            //            tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
            
        }
        //setupInfiniteScrollView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let nav = self.navigationController?.navigationBar
        nav?.barTintColor = UIColor.grayColor()
        nav?.tintColor = UIColor.yellowColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "iconmonstr-home-9-32")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    func networker_Request(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tweets = tweets
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func  refresher_contorl(){
        self.refrechController = UIRefreshControl()
        self.refrechController.attributedTitle = NSAttributedString(string: "Hello")
        
        self.refrechController.addTarget(self,action: "refresher:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refrechController)
        refrechController.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        refrechController.tintColor = UIColor(red: 155/255, green: 155/255, blue: 154/255, alpha: 1)
        
    }
    func refresher(sender:AnyObject){
        self.tableView.reloadData()
        networker_Request()
        self.refrechController.endRefreshing()
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser!.logout()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            
            return tweets.count
            
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsTableViewCell", forIndexPath: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.TimesCreater.text = tweets![indexPath.row].Time!
        return cell
    }
    
    func thubCliked(){
        
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "cellDetials") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetsDetailsViewController = segue.destinationViewController as! DetailTweetsViewController
            tweetsDetailsViewController.tweet = tweet
            
            }
              else if (segue.identifier) == "composeSegue" {
                       let user = User.currentUser
                        let composeTweetViewController = segue.destinationViewController as! ComposeViewController
                        composeTweetViewController.user = user
                        
        }
        
        else if (segue.identifier) == "Reply1Segue" {
                    let button = sender as! UIButton
                    let view = button.superview!
                let cell = view.superview as! TweetsTableViewCell
                    let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
                let user = User.currentUser
            let ReplyTweetViewController = segue.destinationViewController as! ReplyViewController
                    ReplyTweetViewController.tweet = tweet
                    ReplyTweetViewController.user = user
        }
        
        else if (segue.identifier) == "ProfileSegue"{
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetsTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let UserProfilePageViewController = segue.destinationViewController as! ProfileViewController
                UserProfilePageViewController.tweet = tweet
            }

        
    }
    
//    class InfiniteScrollActivityView: UIView {
//        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
//        static let defaultHeight:CGFloat = 60.0
//        
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            setupActivityIndicator()
//        }
//        
//        override init(frame aRect: CGRect) {
//            super.init(frame: aRect)
//            setupActivityIndicator()
//        }
//        
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
//        }
//        
//        func setupActivityIndicator() {
//            activityIndicatorView.activityIndicatorViewStyle = .Gray
//            activityIndicatorView.hidesWhenStopped = true
//            
//            self.addSubview(activityIndicatorView)
//        }
//        
//        func stopAnimating() {
//            self.activityIndicatorView.stopAnimating()
//            self.hidden = true
//        }
//        
//        func startAnimating() {
//            self.hidden = true
//            self.activityIndicatorView.startAnimating()
//        }
//    }
    
//    func setupInfiniteScrollView() {
//        let frame = CGRectMake(0, tableView.contentSize.height,
//            tableView.bounds.size.width,
//            InfiniteScrollActivityView.defaultHeight
//        )
//        loadingMoreView = InfiniteScrollActivityView(frame: frame)
//        loadingMoreView!.hidden = true
//        tableView.addSubview( loadingMoreView! )
//        
//        var insets = tableView.contentInset
//        insets.bottom += InfiniteScrollActivityView.defaultHeight
//        tableView.contentInset = insets
//    }

    
//    func delay(delay: Double, closure: () -> () ) {
//        dispatch_after(
//            dispatch_time(
//                DISPATCH_TIME_NOW,
//                Int64(delay * Double(NSEC_PER_SEC))
//            ),
//            dispatch_get_main_queue(), closure
//        )
//    }

    
//    
//    func loadMoreData(){
//        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
//            
//            if error != nil {
//                self.delay(2.0, closure: {
//                    self.loadingMoreView?.stopAnimating()
//                    //TODO: show network error
//                })
//            } else {
//                self.delay(0.5, closure: { Void in
//                    self.loadMoreOffset += 20
//                    self.tweets!.appendContentsOf(tweets!)
//                    self.tableView.reloadData()
//                    self.loadingMoreView?.stopAnimating()
//                    self.isMoreDataLoading = false
//                })
//            }
//            
//        }
//    }
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        // Handle scroll behavior here
//        if (!isMoreDataLoading) {
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//            
//            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
//                isMoreDataLoading = true
//                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
//                loadingMoreView?.frame = frame
//                loadingMoreView!.startAnimating()
//                
//                //load more data
//                loadMoreData()
//            }
//        }
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "SegueToTweetDetails") {
//            let cell = sender as! UITableViewCell
//            let indexPath = tableView.indexPathForCell(cell)
//            let tweet = tweets![indexPath!.row]
//            
//            let tweetDetailViewController = segue.destinationViewController as! DetailTweetsViewController
//            tweetDetailViewController.tweet = tweet
//        }
//    }

    
    

    
    
}
