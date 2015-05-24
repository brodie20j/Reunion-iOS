//
//  ICSParser.swift
//  Carleton Reunion
//
//  Created by Grant Terrien on 5/22/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import Foundation

@objc class ICSParser: NSObject {
    
    
    
    init(eventDataSource: NewEventDataSource) {
        let path = NSBundle.mainBundle().pathForResource("schedule", ofType: "ics")
        var err : NSError?
        var content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: &err)
        
        
        var calendarManager = MXLCalendarManager()
        
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MM yyyy"
        var date = dateFormatter.dateFromString("18 06 2015")
        
        
        calendarManager.parseICSString(content, withCompletionHandler: { (calendar: MXLCalendar!, error: NSError!) -> Void in
            var events = calendar.events
            var nswEvents = NSMutableArray()
            for event in events {
                var theEvent = event as! MXLCalendarEvent
                
                
                
                var newEvent = NSWEvent(ID: theEvent.eventUniqueID, title: theEvent.eventSummary, description: theEvent.eventDescription, location: theEvent.eventLocation, start: theEvent.eventStartDate, duration: event.eventDuration)
            }
            eventDataSource.populateEventList(nswEvents)
        })
    }
    
    
    

}
