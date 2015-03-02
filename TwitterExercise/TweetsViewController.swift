
//
//  TweetsViewController.swift
//  TwitterExercise
//
//  Created by Shajith on 2/19/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetsTable: UITableView!
    var refreshControl: UIRefreshControl!
    
    private var tweets: [Tweet] = []
    private var currentTweet: Tweet!
    private var userToShow: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(User.currentUser == nil) {
            self.performSegueWithIdentifier("loginSegue", sender: self)
            // Do any additional setup after loading the view, typically from a nib.
            return
        }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        tweetsTable.addSubview(refreshControl)
        
        fetchTweets(nil)
        
        // Do any additional setup after loading the view.

        tweetsTable.delegate = self
        tweetsTable.dataSource = self
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        tweetsTable.estimatedRowHeight = 50.0
        
        NSNotificationCenter.defaultCenter().addObserverForName("status-posted", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            self.fetchTweets(nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("show-current-user", object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            self.showCurrentUser()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell1") as TweetCell
        var tweet = tweets[indexPath.row]
        var user = tweet.user!
        
        cell.tweetLabel.text = tweet.text
        cell.tweetLabel.preferredMaxLayoutWidth = cell.tweetLabel.bounds.width
        
        cell.userImage.setImageWithURL(NSURL(string: user.profileImageURL!))
        cell.userImage.tag = indexPath.row
        var recognizer = UITapGestureRecognizer(target: self, action: "onProfileImagetap:")
        cell.userImage.addGestureRecognizer(recognizer)
        
        cell.nameLabel.text = user.name!        
        cell.screenNameLabel.text = user.screenName!

        cell.timeLabel.text = tweet.createdAt!.shortTimeAgoSinceNow()
        
        cell.favoriteButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        
        if(tweet.retweeted!) {
            cell.retweetButton.imageView!.image = UIImage(named: "retweet_on.png")
        } else {
            cell.retweetButton.imageView!.image = UIImage(named: "retweet.png")
        }
        
        if(tweet.favorited!) {
            cell.favoriteButton.imageView!.image = UIImage(named: "favorite_on.png")
        } else {
            cell.favoriteButton.imageView!.image = UIImage(named: "favorite.png")
        }
    
        //cell.contentView.layoutIfNeeded()
        return cell
    }
    
    func fetchTweets(completion: (() -> Void)?) {
        TwitterClient.sharedInstance.homeTimeline() { (tweets: [Tweet]?, error: NSError?) in
            if(tweets != nil) {
                self.tweets = tweets!
                self.tweetsTable.reloadData()
            } else {
                println("ERROR:\(error!)")
            }
            
            if(completion != nil) {
                completion!()
            }
        }
    }
    
    func refreshTweets() {
        fetchTweets() { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func retweetAction(sender: AnyObject) {
        var button = sender as UIButton
        var tweet = tweets[button.tag]
        
        if(tweet.retweeted!) {
            return
        }
        
        TwitterClient.sharedInstance.retweet(tweet.tweetId!, completion: { (error) -> Void in
            if(error == nil) {
                button.imageView!.image = UIImage(named: "retweet_on.png")
            } else {
                println(error)
            }
        })
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        var button = sender as UIButton
        var tweet = tweets[button.tag]
        
        if(tweet.favorited!) {
            return
        }
        
        TwitterClient.sharedInstance.favorite(tweet.tweetId!, completion: { (error) -> Void in
            if(error == nil) {
                button.imageView!.image = UIImage(named: "favorite_on.png")
            } else {
                println(error)
            }
        })        
    }
        
    @IBAction func replyAction(sender: AnyObject) {
        self.currentTweet = tweets[(sender as UIButton).tag]
        performSegueWithIdentifier("tweetReply", sender: self)
    }
    // MARK: - Navigation

    @IBAction func onProfileImagetap(sender: UITapGestureRecognizer) {
        println(sender.view!.tag)
        userToShow = tweets[sender.view!.tag].user
        performSegueWithIdentifier("showProfile", sender: self)
    }
    
    func showCurrentUser() {
        userToShow = User.currentUser
        performSegueWithIdentifier("showProfile", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "tweetDetail") {
            var vc = segue.destinationViewController as TweetDetailViewController
            var idx = tweetsTable.indexPathForSelectedRow()!.row
            vc.tweet = tweets[idx]
        }

        if(segue.identifier == "tweetReply") {
            var vc = segue.destinationViewController as TweetViewController
            vc.tweetText = "@\(currentTweet.user!.screenName!): "
        }

        if(segue.identifier == "showProfile") {
            var vc = segue.destinationViewController as ProfileViewController
            vc.user = userToShow!
        }

        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onShowMenuAction(sender: UIBarButtonItem) {
        var mainVC = self.navigationController?.parentViewController as MainViewController!
        mainVC.toggleMenu(nil)
    }
}
