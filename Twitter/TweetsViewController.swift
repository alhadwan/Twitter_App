//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ali hadwan on 2/12/16.
//  Copyright © 2016 Ali hadwan. All rights reserved.
//


import UIKit
import MBProgressHUD


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var tweets: [Tweet]?
    var loadingMoreView:InfiniteScrollActivityView?
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
            
            self.tableView.infiniteScrollIndicatorStyle = .Gray
            self.tableView.addInfiniteScrollWithHandler { (scrollView) -> Void in
                let tableView = scrollView as! UITableView
                
                tableView.reloadData()
                
            }
//            tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
            
             }
        setupInfiniteScrollView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.yellowColor()
        // 3
        //        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        //        imageView.contentMode = .ScaleAspectFit
        //        // 4
        //        let image = UIImage(named: "Apple_Swift_Logo")
        //        imageView.image = image
        //        // 5
        //        navigationItem.titleView = imageView
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row")
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    class InfiniteScrollActivityView: UIView {
        var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        static let defaultHeight:CGFloat = 60.0
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupActivityIndicator()
        }
        
        override init(frame aRect: CGRect) {
            super.init(frame: aRect)
            setupActivityIndicator()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
        }
        
        func setupActivityIndicator() {
            activityIndicatorView.activityIndicatorViewStyle = .Gray
            activityIndicatorView.hidesWhenStopped = true
            
            self.addSubview(activityIndicatorView)
        }
        
        func stopAnimating() {
            self.activityIndicatorView.stopAnimating()
            self.hidden = true
        }
        
        func startAnimating() {
            self.hidden = true
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func setupInfiniteScrollView() {
        let frame = CGRectMake(0, tableView.contentSize.height,
            tableView.bounds.size.width,
            InfiniteScrollActivityView.defaultHeight
        )
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview( loadingMoreView! )
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    }
    
    
    func delay(delay: Double, closure: () -> () ) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
    }
    

    
    func loadMoreData(){
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            
            if error != nil {
                self.delay(2.0, closure: {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
                })
            } else {
                self.delay(0.5, closure: { Void in
                    self.loadMoreOffset += 20
                    self.tweets!.appendContentsOf(tweets!)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false
                })
            }
            
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //load more data
                loadMoreData()
            }
        }
    }
    

}
