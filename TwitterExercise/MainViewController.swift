//
//  MainViewController.swift
//  TwitterExercise
//
//  Created by Shajith on 3/2/15.
//  Copyright (c) 2015 zd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var openingMenu: Bool = false
    private var menuIsOpen: Bool = false
    private var tweetsView: UIView!
    private var tweetsVC: TweetsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NavigationRootController") as UINavigationController

        tweetsView = navController.view
        view.addSubview(tweetsView)
        view.bringSubviewToFront(tweetsView)
        
        addChildViewController(navController)
        navController.didMoveToParentViewController(self)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "onSwipe:")
        view.addGestureRecognizer(panGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSwipe(sender: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (sender.velocityInView(view).x > 0)
        
        switch(sender.state) {
        case .Began:
            openingMenu = gestureIsDraggingFromLeftToRight
            break
        case .Changed:
/*            if(openingMenu && (tweetsView.center.x > view.bounds.size.width)) {
                break;
            }
  */
            tweetsView.center.x = tweetsView.center.x + sender.translationInView(view).x
            sender.setTranslation(CGPointZero, inView: view)
        case .Ended:
            if (openingMenu) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = tweetsView.center.x > view.bounds.size.width
                if(hasMovedGreaterThanHalfway) {
                    openMenu(nil)
                } else {
                    closeMenu(nil)
                }
            } else {
                let hasMovedGreaterThanHalfway = tweetsView.center.x < 0
                self.closeMenu(nil)
                
            }
            break
        default:
            break
        }
    }
    
    func toggleMenu(completion: ((Bool) -> Void)?) {
        if(menuIsOpen) {
            closeMenu(completion)
        } else {
            openMenu(completion)
        }
    }
    
    func openMenu(completion: ((Bool) -> Void)?) {
        menuIsOpen = true
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.tweetsView.center.x = self.view.bounds.size.width
            }, completion: completion)
    }
    
    func closeMenu(completion: ((Bool) -> Void)?) {
        menuIsOpen = false
        UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tweetsView.frame.origin.x = 0
            }, completion: completion)
        
    }
    
    @IBAction func onProfileAction(sender: UIButton) {
        println("show current user profile")
        NSNotificationCenter.defaultCenter().postNotificationName("show-current-user", object: nil)
        
        closeMenu { (status) -> Void in
        }
    }

    @IBAction func onHomeTimelineAction(sender: AnyObject) {
        closeMenu(nil)
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
