//
//  TweetDetailViewController.swift
//  TwitterExercise
//
//  Created by Shajith on 2/22/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userscreenName: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetLabel.text = tweet.text
        userImage.setImageWithURL(NSURL(string: tweet.user!.profileImageURL!))
        
        userName.text = tweet.user?.name
        userscreenName.text = tweet.user?.screenName
        
        if(tweet.retweeted!) {
            retweetButton.imageView!.image = UIImage(named: "retweet_on.png")
        } else {
            retweetButton.imageView!.image = UIImage(named: "retweet.png")
        }
        
        if(tweet.favorited!) {
            favoriteButton.imageView!.image = UIImage(named: "favorite_on.png")
        } else {
            favoriteButton.imageView!.image = UIImage(named: "favorite.png")
        }
        
        navigationItem.backBarButtonItem?.title = "Back"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        var button = sender as UIButton
        
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

    @IBAction func retweetAction(sender: AnyObject) {
        var button = sender as UIButton
        
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
    
    @IBAction func replyAction(sender: AnyObject) {
        performSegueWithIdentifier("tweetComposeFromDetail", sender: self)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var vc = segue.destinationViewController as TweetViewController
        vc.tweetText = "@\(tweet.user!.screenName!): "
    }
    

}
