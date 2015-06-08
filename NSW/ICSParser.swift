//
//  ICSParser.swift
//  Carleton Reunion
//
//  Created by Grant Terrien on 5/22/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//
//  Creates NSWEvent objects for use by NewEventDataSource.
//  Uses modified MXLCalendar library by Kiran Panesar to parse iCalendar files
//  https://github.com/KiranPanesar/MXLCalendarManager

import Foundation

@objc class ICSParser: NSObject {
    
    var documentsUrl: NSURL?
    
    init(eventDataSource: NewEventDataSource) {
        super.init()
        let reunionScheduleUrlString = "https://apps.carleton.edu/reunion/schedule/?start_date=2015-06-07&format=ical"
        documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        
        downloadScheduleSynchronously()
        
        let path = documentsUrl!.URLByAppendingPathComponent("schedule.ics").path
        
        //    let path = NSBundle.mainBundle().pathForResource("schedule", ofType: "ics")
        var err : NSError?
        //     var content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &err)
        var content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &err)
        
        
        var calendarManager = MXLCalendarManager()
        
        
        // This is asynchronous. Would have to rewrite much of third party library to not use
        // callback functions.
        calendarManager.parseICSString(content, withCompletionHandler: { (calendar: MXLCalendar!, error: NSError!) -> Void in
            var events = calendar.events
            var nswEvents = NSMutableArray()
            for event in events {
                var theEvent = event as! MXLCalendarEvent
                
                
                var newEvent = NSWEvent(ID: theEvent.eventUniqueID, title: theEvent.eventSummary, description: theEvent.eventDescription, location: theEvent.eventLocation, start: theEvent.eventStartDate, duration: event.eventDuration)
                nswEvents.addObject(newEvent)
            }
            eventDataSource.populateEventList(nswEvents)
        })
    }
    
    
    func downloadScheduleSynchronously() {
        if let scheduleUrl = NSURL(string: "https://apps.carleton.edu/reunion/schedule/?start_date=2015-06-07&format=ical") {
            
            if let scheduleDataFromUrl = NSData(contentsOfURL: scheduleUrl){
                // after downloading your data you need to save it to your destination url
                let destinationUrl = documentsUrl!.URLByAppendingPathComponent("schedule.ics")
                if scheduleDataFromUrl.writeToURL(destinationUrl, atomically: true) {
                    println("file saved at \(destinationUrl)")
                }
                else {
                    println("error saving file")
                }
                return
            }
            
            println("Can't download file. Check your internet connection.")
        }
        else {
            println("error")
        }
    }
    
    
    
    
    
}
