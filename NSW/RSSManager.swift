//
//  RSSManager.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 6/1/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//
//  Manages the RSS Feed for Carleton Reunion.
//  -keeps track of posts
//  -parses RSS feed from url to get the title and description
//  -this is accessed in EventListViewController.m, as that is when we check for updates

import Foundation

@objc class RSSManager: NSObject {
    var currentFeed:String=""
    let feedURL:String="https://apps.carleton.edu/reunion/feeds/blogs/reunionupdates"
    var feedLog: [String: String]=[:]
    var log=["DUMMY"]
    var updates=false
    
    
    
    override init() {
        super.init()
        //since we're being initialized, go get the latest RSS Feed
        self.getLatestFeed()
    }

    
    func getLatestFeed() {
        var html : NSString = NSString(contentsOfURL: NSURL(string:self.feedURL)!, encoding: NSUTF8StringEncoding, error: nil)! as NSString
        println(html)
        self.currentFeed=html as! String
        println(self.currentFeed)
        self.scrapeUpdates()
    }
    
    
    func scrapeUpdates() {
        var rawHTML:String=self.currentFeed
        println("scraping")
        var titleString:String=""
        var descriptionString:String=""
        var dateString:String=""
        var linkString:String=""
        
        
        //Warning: The following is a non-versatile way to parse HTML.  This approach is very narrow and prevents further expansions.  If we had needed to directly access HTML more, I would have looked into constructing a better approach.
        
        while (rawHTML.rangeOfString("<item>") != nil) {
            
            var titleString:String=""
            var descriptionString:String=""
            var dateString:String=""
            var linkString:String=""
            var range=rawHTML.rangeOfString("<item>")!
            
            //get the substring from the <item> tag to the rest of the page
            
            var jankystr=rawHTML.substringWithRange(Range<String.Index>(start: advance(range.endIndex,8), end: rawHTML.endIndex))
            var counter=0
            for char in jankystr {
                if char=="<" {
                    break
                }
                else {
                    titleString.append(char)
                    counter=counter+1
                }
            }
            
            rawHTML=rawHTML.substringWithRange(Range<String.Index>(start: advance(range.endIndex,8+counter),end: rawHTML.endIndex))
            range=rawHTML.rangeOfString("<description>")!
            //get the substring from the <description> tag to the rest of the page
            jankystr=rawHTML.substringWithRange(Range<String.Index>(start: range.endIndex, end: rawHTML.endIndex))
            counter=0
            for char in jankystr {
                if char=="<" {
                    break
                }
                else {
                    descriptionString.append(char)
                    counter=counter+1
                }
            }
            self.feedLog[titleString]=descriptionString
            rawHTML=jankystr
        }
        
    }

    func getCurrentFeed() -> String {
        return self.currentFeed;
    }
    //checks the current feed for logs we have seen before, filters those out, and returns a dictionary of the remaining values
    func getFeedLog() -> [String: String] {
        for i in self.log {
            if let val = self.feedLog[i] {
                self.feedLog.removeValueForKey(i)
            }
        }
        var newLog:[String:String]=[:]
        for title in self.feedLog.keys {
            if self.feedLog[title] != nil {
                newLog[title]=self.feedLog[title]
            }
            //now add these values to our old log
            if !contains(self.log,title) {
                self.log+=[title]
            }
        }

        return newLog
    }
    func clearLog() {
        self.feedLog=[:]
    }
    
    
}