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
#import "EventDetailViewController.h"
#import "CustomPointAnnotation.h"

#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *sportSelectionPopoverView;

@property (weak, nonatomic) IBOutlet UIButton *basketballSelectedButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (weak, nonatomic) NSString *sportSelected;
@property (weak, nonatomic) NSString *addressString;
@property (weak, nonatomic) NSString *selectedPinString;

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

@property PFObject *eventObject;

@end

@implementation MainMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sportSelectionPopoverView.alpha = 0;

    [self.sidebarButton setTarget: self.revealViewController];
    [self.sidebarButton setAction: @selector( revealToggle: )];
    
    [self.dashboardButton setTarget: self.revealViewController];
    [self.dashboardButton setAction: @selector( rightRevealToggle: )];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
       for(PFObject *object in objects)
       {
           self.addressString = object[@"location"];
           NSString *new = [self.addressString stringByAppendingString:@" Chicago, IL"];
           
           NSString *location = new;
           CLGeocoder *geocoder = [[CLGeocoder alloc] init];
           [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error)
           {
               for(CLPlacemark *place in placemarks)
               {
                   CustomPointAnnotation *annotation = [CustomPointAnnotation new];
                   annotation.coordinate = place.location.coordinate;
                   annotation.title = object[@"title"];
                   annotation.sport = object[@"sport"];
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
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(zoomLocation, MKCoordinateSpanMake(0.15, 0.15));
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (IBAction)overlayOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.sportSelectionPopoverView.alpha = 1;
        self.sportSelectionPopoverView.frame = self.view.frame;
    }];
    
    self.bottomImageView.image = [UIImage imageNamed:@"OGchoosesportFooterCLICKED"];
}

-(MKAnnotationView *)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
//    for (CustomPointAnnotation *annotation in self.allEvents)
//    {        
//        if ([annotation.sport isEqualToString:@"Basketball"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportbasketballMAP.png"];
//        }
//        else if ([annotation.sport isEqualToString:@"Baseball"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportbaseballMAP.png"];
//        }
//        else if ([annotation.sport isEqualToString:@"Football"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportfootballMAP.png"];
//        }
//        else if ([annotation.sport isEqualToString:@"Soccer"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportsoccerMAP.png"];
//        }
//        else if ([annotation.sport isEqualToString:@"Tennis"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsporttennisMAP.png"];
//        }
//    }
//    
//    for (CustomPointAnnotation *annotation in self.basketballEventArray)
//    {
//        if ([annotation.sport isEqualToString:@"Basketball"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportbasketballMAP.png"];
//        }
//    }
//    
//    for (CustomPointAnnotation *annotation in self.baseballEventArray)
//    {
//        if ([annotation.sport isEqualToString:@"Baseball"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportbaseballMAP.png"];
//        }
//    }
//    
//    for (CustomPointAnnotation *annotation in self.footballEventArray)
//    {
//        if ([annotation.sport isEqualToString:@"Football"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportfootballMAP.png"];
//        }
//    }
//    
//    for (CustomPointAnnotation *annotation in self.soccerEventArray)
//    {
//        if ([annotation.sport isEqualToString:@"Soccer"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsportsoccerMAP.png"];
//        }
//    }
//    
//    for (CustomPointAnnotation *annotation in self.tennisEventArray)
//    {
//        if ([annotation.sport isEqualToString:@"Tennis"])
//        {
//            pin.image = [UIImage imageNamed:@"OGsporttennisMAP.png"];
//        }
//    }

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"pinDetailSegueID" sender:self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation *selectedAnnotation = view.annotation;
    self.selectedPinString = selectedAnnotation.title;
    
    [self parseDataQueryForAnnotationSelected:self.selectedPinString];
    NSLog(@"%@", self.eventObject);
}

-(void)parseDataQueryForAnnotationSelected: (NSString*) filter
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"title" equalTo:filter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFObject *object in objects)
         {
             self.eventObject = object;
         }
     }];
}

-(void)queryBySportSelected
{
    self.bottomImageView.image = [UIImage imageNamed:@"OGchoosesportFooter"];
    
    NSArray *allPoints = self.mapView.annotations;
    [self.mapView removeAnnotations:allPoints];
    
    [UIView animateWithDuration:.5 animations:^{
        self.sportSelectionPopoverView.alpha = 0;
        self.sportSelectionPopoverView.frame = self.view.frame;
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"sport" equalTo:self.sportSelected];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for(PFObject *object in objects)
         {
             self.addressString = object[@"location"];
             NSString *new = [self.addressString stringByAppendingString:@" Chicago, IL"];
             
             NSString *location = new;
             CLGeocoder *geocoder = [[CLGeocoder alloc] init];
             [geocoder geocodeAddressString:location
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              for(CLPlacemark *place in placemarks)
                              {
                                  CustomPointAnnotation *annotation = [CustomPointAnnotation new];
                                  annotation.coordinate = place.location.coordinate;
                                  annotation.title = object[@"title"];
                                  annotation.sport = object[@"sport"];
                                  
                                  if([self.sportSelected isEqualToString:@"Basketball"])
                                  {
                                      self.basketballEventArray = [NSMutableArray arrayWithObject:annotation];
                                      [self.mapView addAnnotations:self.basketballEventArray];
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
    self.sportSelected = @"Basketball";
    [self queryBySportSelected];
}

- (IBAction)soccerSelected:(UIButton *)sender
{
    self.sportSelected = @"Soccer";
    [self queryBySportSelected];
}

- (IBAction)baseballSelected:(UIButton *)sender
{
    self.sportSelected = @"Baseball";
    [self queryBySportSelected];
}

- (IBAction)tennisSelected:(UIButton *)sender
{
    self.sportSelected = @"Tennis";
    [self queryBySportSelected];
}

- (IBAction)footballSelected:(UIButton *)sender
{
    self.sportSelected = @"Football";
    [self queryBySportSelected];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pinDetailSegueID"])
    {
        EventDetailViewController *evc = segue.destinationViewController;
        evc.eventObject = self.eventObject;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.5 animations:^{
        self.sportSelectionPopoverView.alpha = 0;
        self.sportSelectionPopoverView.frame = self.view.frame;
    }];
    
    self.bottomImageView.image = [UIImage imageNamed:@"OGchoosesportFooter"];
}

@end
