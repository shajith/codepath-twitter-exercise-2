
//
//  User.swift
//  TwitterExercise
//
//  Created by Shajith on 2/19/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "currentUserKey"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var desc: String?
    var dictionary: NSDictionary
    var followersCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        profileImageURL = profileImageURL?.stringByReplacingOccurrencesOfString("_normal", withString: "", options: nil, range: nil)
        
        desc = dictionary["description"] as? String
        followingCount = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
    }
    
    class var currentUser: User? {
        get {
            if(_currentUser == nil) {
              var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if(data != nil) {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            if(_currentUser != nil) {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
