//
//  TwitterViewController.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 5/16/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//
//  View Controller for the Twitter feed

import UIKit
class TwitterViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    var tweetTableViewController: TweetTableViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up navigation bar
        self.setNavigationColors()
        self.navigationItem.title = "Twitter Feed"
        revealButtonItem.target = self.revealViewController()
        revealButtonItem.action = "revealToggle:"
        
        
        
        self.navigationController?.navigationBar.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view.
        
        
        
//        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        activityIndicator.backgroundColor? = NSWStyle.lightBlueColor()
//        activityIndicator.frame = CGRectMake(100, 100, 100, 100);
//        activityIndicator.startAnimating()
//        self.view.addSubview( activityIndicator )
//        self.view.bringSubviewToFront(activityIndicator)
        

        
        }
    


    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Set navbar styling to consistent with rest of app
    func setNavigationColors() {
        var navBar: UINavigationBar = self.navigationController!.navigationBar
        navBar.translucent = false
        navBar.barTintColor = NSWStyle.oceanBlueColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: NSWStyle.whiteColor(),
            NSFontAttributeName: NSWStyle.boldFont()]
        var barBtnItem: UIBarButtonItem = UIBarButtonItem(title: "", style: .Bordered, target: self, action: "popoverArrowDirection:")
        self.navigationItem.backBarButtonItem = revealButtonItem
        self.revealButtonItem.tintColor = NSWStyle.whiteColor()

        
    

    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedTweetTable" {
            tweetTableViewController = segue.destinationViewController as? TweetTableViewController
            tweetTableViewController?.setPVC(self)
        }
         
    }

}
