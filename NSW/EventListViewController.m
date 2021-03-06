//
//  EventListViewController.m
//  NSW
//
//  Created by Stephen Grinich on 5/7/14.
//  Copyright (c) 2014 BTIN. All rights reserved.
//
//  Slightly modified for use in Carleton Reunion
//  In addition to the event data source, we now initialize an RSS Feed that is updated each time the view loads
//  If there are any new alerts, send them to a user in a pop-up window.

#import "EventListViewController.h"

#import "EventDataSource.h"
#import "NSWEvent.h"
#import "EventTableViewCell.h"
#import "EventDetailViewController.h"
#import "NSWStyle.h"
#import "DataSourceManager.h"
#import "iToast.h"
#import "NSWConstants.h"
#import "SWRevealViewController.h"
#import "Carleton_Reunion-Swift.h"



@interface EventListViewController () {
    EventDataSource *myEventDS;
    RSSManager *rssFeed;
    NSDate *currentDate;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation EventListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayDirectionsIfNewUser];


    //Connect this VC to the shared DataSource
    myEventDS = [[DataSourceManager sharedDSManager] getEventDataSource];
    
    //do RSS updates here
    rssFeed =[[DataSourceManager sharedDSManager] getRSSManager];
    rssFeed.getLatestFeed;
    NSDictionary *log=rssFeed.getFeedLog;
    
    //iterate through the keys and their values and display them in a popup-window
    
    for (id key in log) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:key
                                                        message:log[key]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    rssFeed.clearLog;

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:18];
    [comps setMonth:6];
    [comps setYear:2015];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = [gregorian dateFromComponents:comps];
    
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setDay:21];
    [comps2 setMonth:6];
    [comps2 setYear:2015];
    
    NSDate *endDate = [gregorian dateFromComponents:comps2];
    
    
    
    
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    NSDate *today = [calendar dateFromComponents:components];
    
    if (([startDate compare:today] == NSOrderedAscending) && ([endDate compare:today] == NSOrderedDescending)) {
        currentDate = today;
    }
    
    else{
        currentDate = startDate;
    }
    

    
    [myEventDS attachVCBackref:self];
    
    

    
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];

    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerSwipeRight:)];
    
    
    
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    
    // for nav bar
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd"];
    
    // get full day of week
    NSDateFormatter *dayOfWeek = [[NSDateFormatter alloc] init];
    [dayOfWeek setDateFormat:@"EEEE"];
    
    // string for nav bar day name
    NSString *dayName = [dayOfWeek stringFromDate:currentDate];
    
    // string for nav bar date
    NSString *current = [formatter stringFromDate:currentDate];
    
    // Changes "September 04" to "September 4" etc. for all dates. Doesn't matter for dates like "September 20" because NSW doesn't go that long
    NSString *currentDateString = [current stringByReplacingOccurrencesOfString:@"0" withString:@""];
    
    // nav bar ex: "Saturday, Sep 13"
    //currentDate = [NSString stringWithFormat:@"%@%@%@", dayName, @", ", currentDate];
    
    // nav bar ex: "Saturday"
    currentDateString = [NSString stringWithFormat:@"%@", dayName];
    
    // set title for navigation bar
    self.navigationController.navigationBar.topItem.title = currentDateString;
    
    [myEventDS getEventsForDate:currentDate];
}





// Updates the event list to the events for currentDate
-(void)getEventsFromCurrentDate {
    [myEventDS getEventsForDate:currentDate];
}

#pragma mark - Table View

// Updates the label for the current day
-(void)updateDateLabelToCurrentDate {
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"MMM dd"];
    
    
    NSDateFormatter *dayOfWeek = [[NSDateFormatter alloc] init];
    [dayOfWeek setDateFormat:@"EEEE"];
    NSString *dayName = [dayOfWeek stringFromDate:currentDate];
             
    
    
    NSString *current = [time stringFromDate:currentDate];
    NSString *currentDateString = [current stringByReplacingOccurrencesOfString:@"0" withString:@""];
                                  
    currentDateString = [NSString stringWithFormat:@"%@", dayName];
                                  
    self.navigationController.navigationBar.topItem.title = currentDateString;
    
}

// Checks the user defaults and shows directions if this is a first user
-(void)displayDirectionsIfNewUser {
    NSString *returningUserKey = @"returning user";
    //[NSUserDefaults resetStandardUserDefaults];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //BOOL isReturningUser = [userDefaults boolForKey:returningUserKey]; Disabled for testing
    BOOL isReturningUser = true;
    if (!isReturningUser) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Carleton!"
                                                        message:@"Swipe left or right on this screen to view events for different days. NSW begins on Tuesday and ends on Sunday. \n\n Please wait while your schedule is downloaded... "
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        [userDefaults setBool:NO forKey:returningUserKey];
    } else {
        //[userDefaults setBool:NO forKey:returningUserKey];
    }
}

// Updates currentDate then the list of events to one day after the previous day
- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    //TODO Nice-to-have: animation with swipe so that it's less of a sudden change
    NSLog(@"LEFT");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];

    NSString *currentDateString =[formatter stringFromDate:currentDate];
    NSString *toDateString = [formatter stringFromDate:[NSWConstants lastDayOfNSW]];
    
    if (![currentDateString isEqualToString:toDateString]) {
        [self.tableView setContentOffset:CGPointZero animated:NO];
        currentDate = [EventDataSource oneDayAfter:currentDate];
        [self getEventsFromCurrentDate];
        [self updateDateLabelToCurrentDate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        
    }
}

// Updates currentDate then the list of events to one day before the previous day
- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
    NSLog(@"RIGHT");
    
    
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *currentDateString =[formatter stringFromDate:currentDate];
    
        NSString *toDateString = [formatter stringFromDate:[NSWConstants firstDayOfNSW]];
    
        if (![currentDateString isEqualToString:toDateString]) {
            [self.tableView setContentOffset:CGPointZero animated:NO];
            currentDate = [EventDataSource oneDayBefore:currentDate];
            [self getEventsFromCurrentDate];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            [self updateDateLabelToCurrentDate];

        }
        
    
    
}



- (IBAction)calendarButton:(id)sender {
        
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select a day to jump to" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                           @"Thurday, June 18",
                           @"Friday, June 19",
                           @"Saturday, June 20",
                           @"Sunday, June 21",
                           nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];

    
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *dateString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];

    
    if(buttonIndex == 0){
        dateString = @"2015-06-18";
        [self.tableView setContentOffset:CGPointZero animated:NO];
        currentDate = [formatter dateFromString:dateString];
        [self getEventsFromCurrentDate];
        [self updateDateLabelToCurrentDate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    if(buttonIndex == 1){
        dateString = @"2015-06-19";
        [self.tableView setContentOffset:CGPointZero animated:NO];
        currentDate = [formatter dateFromString:dateString];
        [self getEventsFromCurrentDate];
        [self updateDateLabelToCurrentDate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    }
    
    if(buttonIndex == 2){
        dateString = @"2015-06-20";
        [self.tableView setContentOffset:CGPointZero animated:NO];
        currentDate = [formatter dateFromString:dateString];
        [self getEventsFromCurrentDate];
        [self updateDateLabelToCurrentDate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    if(buttonIndex == 3){
        dateString = @"2015-06-21";
        [self.tableView setContentOffset:CGPointZero animated:NO];
        currentDate = [formatter dateFromString:dateString];
        [self getEventsFromCurrentDate];
        [self updateDateLabelToCurrentDate];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
    else{
        
    }
    
    
   
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[NSWStyle oceanBlueColor] forState:UIControlStateNormal];
        }
    }
}





- (EventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSWEvent *event = self.listItems[(NSUInteger) indexPath.row];
    
    //Optionally for time zone conversions
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSDateFormatter *time = [[NSDateFormatter alloc] init];
    [time setDateFormat:@"hh:mm a"];

    NSString *startTime = [time stringFromDate:event.startDateTime];
    NSString *endTime = [time stringFromDate:event.endDateTime];
    
    if ([[startTime substringToIndex:1] isEqualToString:@"0"]){
        startTime = [startTime substringFromIndex:1];
    }
    
    if ([[endTime substringToIndex:1] isEqualToString:@"0"]){
        endTime = [endTime substringFromIndex:1];
    }
    
    // Removes end time if start time and end time are the same. Also adds hyphen accordingly. 
    NSString *startEnd;
    if ([startTime isEqualToString:endTime]) {
        endTime = @"";
        startEnd = startTime;
    }
    else{
        startEnd = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    }
    
    cell.startEndLabel.text = startEnd;
    cell.startEndLabel.textColor = [NSWStyle darkBlueColor];
    
    
    // Remove "NSW: " from event title
    NSString *eventNameString = [event title];
    NSString *eventNameStringFirstFourChars = [eventNameString substringToIndex:5];
    if([eventNameStringFirstFourChars  isEqual: @"NSW: "]){
        eventNameString = [eventNameString substringFromIndex:5];
    }
    
    
    
    cell.eventNameLabel.text = eventNameString;
    cell.eventNameLabel.textColor = [NSWStyle darkBlueColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"showDetail" sender:self];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSWEvent *object = self.listItems[(NSUInteger) indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (BOOL)inputDate:(NSDate*)date start:(NSDate*)beginDate end:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}



@end
