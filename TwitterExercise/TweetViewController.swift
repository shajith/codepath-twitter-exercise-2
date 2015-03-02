//
//  TweetViewController.swift
//  TwitterExercise
//
//  Created by Shajith on 2/22/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    var tweetText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.text = tweetText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postAction(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(tweetTextView.text, completion: { (error: NSError?) -> Void in
            if(error != nil) {
                println(error!)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("status-posted", object: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
