//
//  ProfileViewController.swift
//  TwitterExercise
//
//  Created by Shajith on 3/1/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

extension Int {
    func abbreviateNumber() -> String {
        func floatToString(val: Float) -> String {
            var ret: NSString = NSString(format: "%.1f", val)
            
            var c = ret.characterAtIndex(ret.length - 1)
            
            if c == 46 {
                ret = ret.substringToIndex(ret.length - 1)
            }
            
            return ret as String
        }
        
        var abbrevNum = ""
        var num: Float = Float(self)
        
        if num >= 1000 {
            var abbrev = ["K","M","B"]
            
            for var i = abbrev.count-1; i >= 0; i-- {
                var powet = Double(i+1) * 3.0
                var sizeInt = pow(10.0, Double((i+1)*3))
                var size = Float(sizeInt)
                
                if size <= num {
                    num = num/size
                    var numStr: String = floatToString(num)
                    if numStr.hasSuffix(".0") {
                        numStr = numStr.substringToIndex(advance(numStr.startIndex,countElements(numStr)-2))
                    }
                    
                    var suffix = abbrev[i]
                    abbrevNum = numStr+suffix
                }
            }
        } else {
            abbrevNum = "\(num)"
            if abbrevNum.hasSuffix(".0") {
                abbrevNum = abbrevNum.substringToIndex(advance(abbrevNum.startIndex, countElements(abbrevNum)-2))
            }
        }
        
        return abbrevNum
    }
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setImageWithURL(NSURL(string: user.profileImageURL!))
        screenNameLabel.text = "@\(user.screenName!)"
        nameLabel.text = user.name!
        
        tweetCountLabel.text = "\(user.tweetCount!.abbreviateNumber()) tweets"
        followerCountLabel.text = "\(user.followersCount!.abbreviateNumber()) followers"
        followingCountLabel.text = "\(user.followingCount!.abbreviateNumber()) following"
        
        
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

}
