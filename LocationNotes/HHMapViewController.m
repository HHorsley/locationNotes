//
//  HHMapViewController.m
//  LocationNotes
//
//  Created by Hunter Horsley on 4/2/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import "HHMapViewController.h"
#import "HHAppDelegate.h"
#import "HHNoteViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HHMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableDictionary *notesDictionary;
@property (nonatomic) float lat;
@property (nonatomic) float lon;

//temp vars
@property (nonatomic, strong) NSString *titleToShow;
@property (nonatomic, strong) NSString *descriptionToShow;
@property (nonatomic, strong) NSString *commentToShow;

//make appDelegate a property
@property (nonatomic, strong) HHAppDelegate *appDelegate;


@end

@implementation HHMapViewController

- (HHAppDelegate *)appDelegate
{
    if (! _appDelegate) {
        _appDelegate = (HHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
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
    [self.mapView setDelegate:self];
    if ([CLLocationManager locationServicesEnabled] == YES)
    {
        NSLog(@"Location Services Enabled: Yes");
        [self.locationManager startUpdatingLocation];
        //zoom
        MKCoordinateSpan span;
        span.latitudeDelta = 0.8;
        span.longitudeDelta = 0.8;
        
        //starting point for map
        CLLocationCoordinate2D start;
        start.latitude = 39.856996;
        start.longitude = -75.109863;
        
        // create region, consisting of span and location
        MKCoordinateRegion region;
        region.span = span;
        region.center = start;
        
        [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Off:"
                                                        message:@"Hey! We can't find you. Head over to your Settings and give this app location permission."
                                                       delegate:nil
                                              cancelButtonTitle:@"Got it!"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.locationManager startUpdatingLocation];

    NSArray *notesArray = [self.appDelegate loadAllNotes];
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    self.notesDictionary = [[NSMutableDictionary alloc] init];
    for (Note *n in notesArray ) {
        MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
        pin.title = n.noteTitle;
        pin.coordinate = CLLocationCoordinate2DMake ([n.noteLatitude floatValue], [n.noteLongitude floatValue]);
        [annotations addObject:pin];
        [self.notesDictionary setObject:n forKey:n.noteTitle];
    }
    
    [self.mapView showAnnotations:annotations animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    pinView.rightCalloutAccessoryView = rightButton;
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Go to edit view
    Note *temp = (Note *) [self.notesDictionary objectForKey:view.annotation.title];
    self.titleToShow = temp.noteTitle;
    self.descriptionToShow = temp.noteDescription;
    self.commentToShow = temp.noteComment;
    [self performSegueWithIdentifier:@"viewNote" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"viewNote"]){
        HHNoteViewController *destination = (HHNoteViewController *) segue.destinationViewController;
        destination.noteTitle = _titleToShow;
        destination.noteDescription = _descriptionToShow;
        destination.noteComment = _commentToShow;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    CLLocation *locationToGeocode = [locations objectAtIndex:0];
    
    [reverseGeocoder reverseGeocodeLocation:locationToGeocode
                          completionHandler:^(NSArray *placemarks, NSError *error){
                              if (!error) {

                                  
                                  self.lat = locationToGeocode.coordinate.latitude;
                                  self.lon = locationToGeocode.coordinate.longitude;
                                  
                              }
                          }];
}

@end
