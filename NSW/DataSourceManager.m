//
// Created by Alex Simonides on 6/1/14.
// Copyright (c) 2014 BTIN. All rights reserved.
//
// Modified by Grant Terrien and Jonathan Brodie for Carleton Reunion
// Added New Event Data Source and RSSManager to the Data Source Manager

#import "DataSourceManager.h"
#import "EventDataSource.h"
#import "Carleton_Reunion-Swift.h"

@interface DataSourceManager ()
    @property NewEventDataSource *eventDataSource;
    @property RSSManager *rssSource;

@end



@implementation DataSourceManager

#pragma mark ---- Initializers

static DataSourceManager *sharedDSManager = nil;

// Returns the singleton DataSourceManager
+(id)sharedDSManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedDSManager == nil) {
            sharedDSManager = [[self alloc] initPrivate];
        }
    });
    return sharedDSManager;
}

// this is a private init method (hidden). The real init method raise an exception. Like a real init method
// here we call [super init]
- (id)initPrivate {
    NSLog(@"Data Source Manager initialized.");
    if (self = [super init]) {
        self.eventDataSource = [[NewEventDataSource alloc] init];
        self.rssSource=[[RSSManager alloc] init];
    }
    return self;
}

// raise an exception
- (id)init {
    [NSException exceptionWithName:@"InvalidOperation" reason:@"Cannot invoke init on a Singleton class. Use sharedDSManager." userInfo:nil];
    return nil;
}

#pragma mark ---- Getters

- (EventDataSource *) getEventDataSource {
    // We need to make this (and EventListViewController) explicitly return/use NewEventDataSource type
    return self.eventDataSource;
}

- (RSSManager *)getRSSManager {
    return self.rssSource;
}
@end