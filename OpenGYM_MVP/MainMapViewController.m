//
//  MainMapViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/12/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "MainMapViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainMapViewController ()

@property (weak, nonatomic) IBOutlet UIView *sportSelectionPopoverView;
@property (weak, nonatomic) IBOutlet UIButton *basketballSelectedButton;
@property (weak, nonatomic) NSString *sportSelected;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSString *addressString;
@property (weak, nonatomic) CLPlacemark *topResult;
@property MKPlacemark *placemark;

@end

@implementation MainMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//    {
//        for(PFObject *object in objects)
//        {
//            self.addressString = object[@"address"];
//            NSString *new = [self.addressString stringByAppendingString:@" Chicago, IL"];
//            NSLog(@"%@", self.addressString);
//            
//            NSString *location = new;
//            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//            [geocoder geocodeAddressString:location
//                         completionHandler:^(NSArray* placemarks, NSError* error){
//                             if (placemarks && placemarks.count > 0) {
//                                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
//                                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
//                                 
//                                 MKCoordinateRegion region = self.mapView.region;
//                                 region.center = placemark.region.center;
//                                 region.span.longitudeDelta /= 8.0;
//                                 region.span.latitudeDelta /= 8.0;
//                                 
//                                 [self.mapView setRegion:region animated:YES];
//                                 [self.mapView addAnnotation:placemark];
//                             }
//                         }
//             ];
//        }
//    }];
}

- (IBAction)overlayOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.sportSelectionPopoverView.frame = self.view.frame;
    }];
}

-(void)queryBySportSelected
{
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

             NSLog(@"%@", object[@"address"]);
             
             NSString *location = new;
             CLGeocoder *geocoder = [[CLGeocoder alloc] init];
             [geocoder geocodeAddressString:location
                          completionHandler:^(NSArray* placemarks, NSError* error){
                              for(CLPlacemark *place in placemarks)
                              {
                                  MKPointAnnotation *annotation = [MKPointAnnotation new];
                                  annotation.coordinate = place.location.coordinate;
                                  
                                  if([self.sportSelected isEqualToString:@"Basketball"])
                                  {
                                      
                                  }
                                  
                                  [self.mapView addAnnotation:annotation];
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
