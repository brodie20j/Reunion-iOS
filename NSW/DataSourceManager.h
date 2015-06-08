//
// Created by Alex Simonides on 6/1/14.
// Copyright (c) 2014 BTIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventDataSource.h"
#import "Carleton_Reunion-Swift.h"



@interface DataSourceManager : NSObject

+ (id) sharedDSManager;

-(EventDataSource *) getEventDataSource;
-(RSSManager *) getRSSManager;

@end