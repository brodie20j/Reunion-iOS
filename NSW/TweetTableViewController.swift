//
//  TwitterViewController.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 5/24/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import UIKit
import TwitterKit

class TweetTableViewController: TWTRTimelineViewController {
    
    var pvc: TwitterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTwitterFeed("CarletonCollege")
        
        
        // We want to hide the view until the content is loaded
        self.tableView.hidden = true
        
        
        
    }

    
    
    //setTwitterFeed
    
    //Constructs a data source for a timeline with timelineName as the screen name of the timeline
    //Note: the screen name of a timeline is merely the user's account without the "@" symbol
    func setTwitterFeed(timelineName: String) {
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            if let validSession = session {
                let client = Twitter.sharedInstance().APIClient
                
                /*
                if we wanted to be efficient and careful with how often we request updates from Twitter, we could construct a
                Twitter data source and initialize it with the rest of the data sources when the app is launched, but since
                these requests are so small, and Twitter is updated so frequently, it makes sense to construct a new data
                source each time to ensure that the feed the user gets is up-to-date
                */

                self.dataSource=TWTRSearchTimelineDataSource(searchQuery: "#carlreunion", APIClient: client)
            } else {
                println("error: %@", error.localizedDescription);
            }
        }
        
    }
    
    // Only enable view once content is being displayed (so we don't see an empty table for half a second)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        self.tableView.hidden = false
        pvc?.stopActivityIndicator()
        return cell
    }
    
    
    
    func setPVC(viewController: TwitterViewController) {
        pvc = viewController
    }
    }