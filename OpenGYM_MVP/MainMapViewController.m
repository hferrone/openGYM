//
//  MainMapViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/12/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "MainMapViewController.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "MapAnnotationDetailViewController.h"

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@interface MainMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *sportSelectionPopoverView;

@property (weak, nonatomic) IBOutlet UIButton *basketballSelectedButton;

@property (weak, nonatomic) NSString *sportSelected;
@property (weak, nonatomic) NSString *addressString;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) CLPlacemark *topResult;
@property MKPlacemark *placemark;

@property NSMutableArray *allEvents;
@property NSMutableArray *basketballEventArray;
@property NSMutableArray *soccerEventArray;
@property NSMutableArray *baseballEventArray;
@property NSMutableArray *tennisEventArray;
@property NSMutableArray *footballEventArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dashboardButton;

@property CLLocationCoordinate2D *detailAnnotation;

@end

@implementation MainMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.dashboardButton setTarget: self.revealViewController];
        [self.dashboardButton setAction: @selector( rightRevealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
       for(PFObject *object in objects)
       {
           self.addressString = object[@"address"];
           NSString *new = [self.addressString stringByAppendingString:@" Chicago, IL"];
           
           NSString *location = new;
           CLGeocoder *geocoder = [[CLGeocoder alloc] init];
           [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error)
           {
               for(CLPlacemark *place in placemarks)
               {
                   MKPointAnnotation *annotation = [MKPointAnnotation new];
                   annotation.coordinate = place.location.coordinate;
                   annotation.title = object[@"title"];
                   self.allEvents = [NSMutableArray arrayWithObject:annotation];
                   [self.mapView addAnnotations:self.allEvents];
               }
           }];
       }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(zoomInOnLoad) withObject:nil afterDelay:2];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(void)zoomInOnLoad
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 41.850033;
    zoomLocation.longitude= -87.650052;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, MKCoordinateSpanMake(0.4, 0.4));
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (IBAction)overlayOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.sportSelectionPopoverView.frame = self.view.frame;
    }];
}

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"pinDetailSegueID" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([segue.identifier isEqualToString:@"pinDetailSegueID"])
//    {
//        MapAnnotationDetailViewController *detailVC = segue.destinationViewController;
//        detailVC.annotationView = self.detailAnnotation;
//    }
}

-(void)queryBySportSelected
{
    NSArray *allPoints = self.mapView.annotations;
    [self.mapView removeAnnotations:allPoints];
    
    NSLog(@"%@", self.sportSelected);
    [UIView animateWithDuration:0.3 animations:^{
        self.sportSelectionPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"sport" equalTo:self.sportSelected];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for(PFObject *object in objects)
         {
             self.addressString = object[@"address"];
             NSString *new = [self.addressString stringByAppendingString:@" Chicago, IL"];
             
             NSString *location = new;
             CLGeocoder *geocoder = [[CLGeocoder alloc] init];
             [geocoder geocodeAddressString:location
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              for(CLPlacemark *place in placemarks)
                              {
                                  MKPointAnnotation *annotation = [MKPointAnnotation new];
                                  annotation.coordinate = place.location.coordinate;
                                  annotation.title = object[@"title"];
                                  
                                  if([self.sportSelected isEqualToString:@"Basketball"])
                                  {
                                      self.basketballEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.basketballEventArray];
                                      
                                      NSArray *test = [NSArray arrayWithObject:object[@"address"]];
                                      PFObject *arrayTest = [PFObject objectWithClassName:@"arrayTest"];
                                      arrayTest[@"address"] = test;
                                      [arrayTest saveInBackground];
                                  }
                                  else if([self.sportSelected isEqualToString:@"Soccer"])
                                  {
                                      self.soccerEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.soccerEventArray];
                                  }
                                  else if([self.sportSelected isEqualToString:@"Baseball"])
                                  {
                                      self.baseballEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.baseballEventArray];
                                  }
                                  else if([self.sportSelected isEqualToString:@"Tennis"])
                                  {
                                      self.tennisEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.tennisEventArray];
                                  }
                                  else if([self.sportSelected isEqualToString:@"Football"])
                                  {
                                      self.footballEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.footballEventArray];
                                  }
                              }
                          }
              ];
         }
     }];
}

- (IBAction)basketballSelected:(UIButton *)sender
{
    self.sportSelected = sender.currentTitle;
    [self queryBySportSelected];
}

- (IBAction)soccerSelected:(UIButton *)sender
{
    self.sportSelected = sender.currentTitle;
    [self queryBySportSelected];
}

- (IBAction)baseballSelected:(UIButton *)sender
{
    self.sportSelected = sender.currentTitle;
    [self queryBySportSelected];
}

- (IBAction)tennisSelected:(UIButton *)sender
{
    self.sportSelected = sender.currentTitle;
    [self queryBySportSelected];
}

- (IBAction)footballSelected:(UIButton *)sender
{
    self.sportSelected = sender.currentTitle;
    [self queryBySportSelected];
}

@end
