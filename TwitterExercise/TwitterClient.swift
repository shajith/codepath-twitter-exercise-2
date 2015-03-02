//
//  TwitterClient.swift
//  TwitterExercise
//
//  Created by Shajith on 2/19/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

let twitterConsumerKey = ""
let twitterConsumerSecret = ""
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> Void)?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)

        }
        
        return Static.instance
    }
    
    func login(completion: (user: User?, error: NSError?) -> Void) {
        loginCompletion = completion

        requestSerializer.clearAuthorizationHeader()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterexercise://oauth"), scope: nil, success: { (oauthCredential: BDBOAuth1Credential!) -> Void in
            println("Got the request token")
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(oauthCredential.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            }, failure: { (error: NSError!) -> Void in
                if(self.loginCompletion != nil) {
                  self.loginCompletion!(user: nil, error: error)
                  self.loginCompletion = nil
                }
        })

    }
    
    func homeTimeline(completion: (tweets: [Tweet]?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json",
            parameters: ["include_my_retweet": true],
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
                var tweets = Tweet.fromArray(response as [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
        
    }
    
    func postTweet(tweet: String, completion: (error: NSError?) -> Void) {
        
        self.POST("1.1/statuses/update.json", parameters: ["status": tweet], success: { (operation, response) -> Void in
            completion(error: nil)
        }, failure: { (operation, error) -> Void in
            completion(error: error)
        })
    }
    
    func retweet(tweetId: String, completion: (error: NSError?) -> Void) {
        self.POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, success: { (operation, response) -> Void in
            completion(error: nil)
            }, failure: { (operation, error) -> Void in
            completion(error: error)
        })
    }

    func favorite(tweetId: String, completion: (error: NSError?) -> Void) {
        self.POST("1.1/favorites/create.json", parameters: ["id": tweetId], success: { (operation, response) -> Void in
            completion(error: nil)
            }, failure: { (operation, error) -> Void in
                completion(error: error)
        })
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
                parameters: nil,
                success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    var user = User(dictionary: response as NSDictionary)
                    User.currentUser = user
                    self.loginCompletion!(user: user, error: nil)
                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    self.loginCompletion!(user: nil, error: error)
                })
                        
            }, failure: { (error: NSError!) -> Void in
                self.loginCompletion!(user: nil, error: error)
        })
        
    }
       
}
