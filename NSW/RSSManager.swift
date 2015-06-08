//
//  RSSManager.swift
//  Carleton Reunion
//
//  Created by Jonathan Brodie on 6/1/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import Foundation

@objc class RSSManager: NSObject {
    var currentFeed:String=""
    let session=NSURLSession.sharedSession()
    let feedURL:String="https://apps.carleton.edu/reunion/feeds/blogs/reunionupdates"
    var feedLog: [String: String]=[:]
    
    
    
    override init() {
        super.init()
        //since we're being initialized, go get the latest RSS Feed
        self.currentFeed=self.getLatestFeed()
        self.scrapeUpdates()
    }
    
    
    func getLatestFeed()->String {
        var strresponse=""
        var request = NSMutableURLRequest(URL: NSURL(string: feedURL)!)
        request.HTTPMethod="GET"
        var err: NSError?
        var strData:String=""
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task=self.session.dataTaskWithRequest(request, completionHandler: {
            data, response, error -> Void in
            if((error) != nil) {
                println(error.localizedDescription)
            }
            
            strData = NSString(data: data, encoding: NSASCIIStringEncoding) as! String
            println(strData)
        })
        task.resume()
        return strData
        return "ERROR"
    }
    //This function returns true if the feed was updated and false if it wasn't
    func updateFeed()->Bool {
        var updated=false
        if (self.currentFeed != self.getLatestFeed()) {
            updated=true
            self.currentFeed=self.getLatestFeed()
            self.scrapeUpdates()
        }
        
        return updated
    }
    
    
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            var errorString:String="Error"
            if error != nil {
                //callback(errorString, error.localizedDescription)
            } else {
                var result = NSString(data: data, encoding:NSASCIIStringEncoding)! as String
                callback(result, nil)
            }
        }
        task.resume()
    }
    
    func scrapeUpdates() {
        var rawHTML:String=self.getLatestFeed()
        println("scraping")
        var titleString:String=""
        var descriptionString:String=""
        var dateString:String=""
        var linkString:String=""
        
        println("kenneth"+rawHTML)
        
        if (rawHTML.rangeOfString("<item>") != nil) {
            
            var titleString:String=""
            var descriptionString:String=""
            var dateString:String=""
            var linkString:String=""
            var range=rawHTML.rangeOfString("<item>")!
            var jankystr=rawHTML.substringWithRange(Range<String.Index>(start: advance(range.endIndex,7), end: rawHTML.endIndex))
            for char in jankystr {
                if char=="<" {
                    break
                }
                else {
                    titleString.append(char)
                }
            }
            range=rawHTML.rangeOfString("<description>")!
            println(range)
            jankystr=rawHTML.substringWithRange(Range<String.Index>(start: range.endIndex, end: rawHTML.endIndex))
            for char in jankystr {
                if char=="<" {
                    break
                }
                else {
                    descriptionString.append(char)
                }
            }
            /*
            range=rawHTML.rangeOfString("<pubDate>")!
            println(range)
            jankystr=rawHTML.substringWithRange(Range<String.Index>(start: range.endIndex, end: rawHTML.endIndex))
            for char in jankystr {
            if char=="<" {
            break
            }
            else {
            dateString.append(char)
            }
            }
            range=rawHTML.rangeOfString("<link>")!
            println(range)
            jankystr=rawHTML.substringWithRange(Range<String.Index>(start: range.endIndex, end: rawHTML.endIndex))
            for char in jankystr {
            if char=="<" {
            break
            }
            else {
            dateString.append(char)
            }
            }
            */
            
            println("We did our bull shit")
            self.feedLog[titleString]=descriptionString
            
            println("endless loop?")
            
            rawHTML=jankystr
        }
        else {
            println("well shit")
        }
        
    }
    func getAlerts() {
        for title in self.feedLog.keys {
            println(title)
            println(self.feedLog[title])
        }
    }
    func adsdsaString() {
        
    }
    
    
}