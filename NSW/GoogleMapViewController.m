//
//  GoogleMapViewController.m
//  NSW
//
//  Created by Lab User on 6/3/14.
//  Copyright (c) 2014 BTIN. All rights reserved.
//
//  ***Slightly modified for better user experience in Carleton NSW***
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SWRevealViewController.h"
#import "NSWStyle.h"
#import "MapLocationsTableViewController.h"

@interface GoogleMapViewController ()
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@end

@implementation GoogleMapViewController{
    GMSMapView *mapView_;
    GMSMarker *marker_;
    GMSCameraPosition *cameraPosition_;
    CLLocationManager *locationManager;
    CLLocation *position;
    BOOL didCheckIfNearCampus;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    marker_ = nil;
    
    mapView_ = [aStoryboard instantiateViewControllerWithIdentifier:@"gMap"];
    
    didCheckIfNearCampus = NO;
    
    self.locationButton.layer.cornerRadius = 5;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.delegate = self;
    // For iOS 8
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];

    
    
    cameraPosition_ = [GMSCameraPosition cameraWithLatitude:44.461
                                                            longitude:-93.1546
                                                                 zoom:17];
    
    
    
    // Disable button if not allowed to use location services
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        self.locationButton.enabled = false;
        self.locationButton.hidden = true;
    }
    
    
    
    
    int width = [UIScreen mainScreen].bounds.size.width;
    int height = [UIScreen mainScreen].bounds.size.height;
    
    
    
    
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, width,height) camera:cameraPosition_];
    mapView_.myLocationEnabled = YES;
    
    
    

    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(buttonTouched)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    [button setTitle:@"Looking for something?" forState:UIControlStateNormal];
    button.layer.cornerRadius = 10;
    button.clipsToBounds = YES;
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [button sizeToFit];
    button.frame = CGRectMake(30, height-120, 260, 35);
    [button setBackgroundColor:[NSWStyle oceanBlueColor]];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18];

    [self.view insertSubview:button atIndex:1];
    [self.view insertSubview:mapView_ atIndex:0];
    
    
    
    
    self.navigationItem.title = @"Campus Map";
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    [self setNavigationColors];
    
	
}

-(void)buttonTouched{
    
    
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"Main"
                                                     bundle:nil];
    MapLocationsTableViewController *mapChoiceController = [sboard instantiateViewControllerWithIdentifier:@"MapChoiceController"];
    
    mapChoiceController.delegate = self;
    [[self navigationController] presentModalViewController:mapChoiceController animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];

}

- (void)addItemViewController:(MapLocationsTableViewController *)controller didFinishEnteringItem:(MapLocation *)locationObject
{
    
    marker_ = [[GMSMarker alloc]init];
    marker_ = [locationObject coordinates];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    
    [mapView_ clear];
    
    GMSCameraPosition *currentPosition = cameraPosition_;
    marker_.map = mapView_;
    cameraPosition_ = [GMSCameraPosition cameraWithTarget:marker_.position zoom:17];
    
    if (marker_ != nil) {
        // Slowed to allow user to orient themselves when map moves... Zooms out and then in
        double intermediateLong = (currentPosition.target.longitude + cameraPosition_.target.longitude)/2;
        double intermidateLat = (currentPosition.target.latitude + cameraPosition_.target.latitude)/2;
        GMSCameraPosition *intermediatePosition = [GMSCameraPosition cameraWithLatitude:intermidateLat longitude:intermediateLong zoom:15];
        [CATransaction setCompletionBlock:^{
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat: 1.0] forKey:kCATransactionAnimationDuration];
            [mapView_ animateToCameraPosition:cameraPosition_];
            [CATransaction commit];
            [mapView_ setSelectedMarker:marker_];
        }];
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat: 1.0] forKey:kCATransactionAnimationDuration];
        [mapView_ animateToCameraPosition:intermediatePosition];
        [CATransaction commit];
        
    }
    
}



//This is directly lifted from BaseNSWTableViewController, can we put it in an interface or such?
- (void)setNavigationColors{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.translucent = NO;
    navBar.barTintColor = [NSWStyle oceanBlueColor];
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName : [NSWStyle whiteColor],
                                     NSFontAttributeName : [NSWStyle boldFont]}];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(popoverArrowDirection)];
    self.navigationItem.backBarButtonItem = barBtnItem;
    //"navBar text color" = [NSWStyle whiteColor];
    self.revealButtonItem.tintColor = [NSWStyle whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Want to scroll to user location if they're on or near campus
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!didCheckIfNearCampus) {
        position = [locations lastObject];
        CLLocation *carletonPosition = [[CLLocation alloc]initWithLatitude:44.461 longitude:-93.1546];
        CLLocationDistance distance = [carletonPosition distanceFromLocation:position];
        NSLog(@"%f", distance);
        if (distance < 2000) {
            cameraPosition_ = [GMSCameraPosition cameraWithLatitude:position.coordinate.latitude longitude:position.coordinate.longitude zoom:17];
            [mapView_ animateToCameraPosition:cameraPosition_];
        }
        didCheckIfNearCampus = YES;
    }
    
}
- (IBAction)didTouchLocationButton:(id)sender {
    cameraPosition_ = [GMSCameraPosition cameraWithLatitude:position.coordinate.latitude longitude:position.coordinate.longitude zoom:17];
    [mapView_ animateToCameraPosition:cameraPosition_];
}

@end
