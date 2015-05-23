//
//  NewEventDataSource.swift
//  Carleton Reunion
//
//  Created by Grant Terrien on 5/23/15.
//  Copyright (c) 2015 BTIN. All rights reserved.
//

import Foundation

@objc class NewEventDataSource: NSObject {
    
    var fullEventList : NSMutableArray
    
    override init() {
        fullEventList = NSMutableArray()
        super.init()
        
        let parser = ICSParser(eventDataSource: self)
    
    }
    
    func populateEventList(calendar: MXLCalendar) {
        for event in calendar.events {
            print(event.title)
//            var newEvent = NSWEvent(ID: event.identifier, title: event.title, description: event.description, location: event.location, start: event.startDateTime, duration: event.duration)
//            self.fullEventList.addObject(newEvent)
        }
        print("\n \n")
        print("Event list populated")
        print("\n \n")

    }
}
