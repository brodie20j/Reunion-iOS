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
    var myTableViewController : EventListViewController?
    
    override init() {
        self.fullEventList = NSMutableArray()
        super.init()
        let parser = ICSParser(eventDataSource: self)
    
    }
    
    func populateEventList(eventList: NSMutableArray?) {
        self.fullEventList = eventList!
        

    }
    
    
    // Used by EventListViewController
    func attachVCBackref(tableViewController: EventListViewController) {
            myTableViewController = tableViewController
            self.myTableViewController!.setVCArrayToDataSourceArray(self.fullEventList as [AnyObject])
        }
    
    func getEventsForDate(currentDate: NSDate) {
        var currentDateComps: NSDateComponents = NSWEvent.getDateComponentsFromDate(currentDate)
        var predicateFormat: NSString = "startDateComponents.day = \(currentDateComps.day) && startDateComponents.month == \(currentDateComps.month) && startDateComponents.year == \(currentDateComps.year)"
        var dateMatchesCurrent: NSComparisonPredicate = NSComparisonPredicate(format: predicateFormat as String)
        var todaysEvents: NSArray = self.fullEventList.filteredArrayUsingPredicate(dateMatchesCurrent)
        
        self.myTableViewController?.setVCArrayToDataSourceArray(todaysEvents as [AnyObject])
        
        
    }
    
    
    }

