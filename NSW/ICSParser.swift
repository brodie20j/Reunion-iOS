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
    
    
    
    init(eventDataSource: NewEventDataSource) {
        let path = NSBundle.mainBundle().pathForResource("schedule", ofType: "ics")
        var err : NSError?
        var content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &err)
        
        
        var calendarManager = MXLCalendarManager()
        
        
        // This is asynchronous, race condition possible? Would have to rewrite much of third party library to not use
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
    
    
    

}
