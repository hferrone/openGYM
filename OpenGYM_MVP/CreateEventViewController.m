//
//  CreateEventViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/12/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *eventSport;
@property (weak, nonatomic) IBOutlet UITextField *eventName;
@property (weak, nonatomic) IBOutlet UITextField *eventAddress;
@property (weak, nonatomic) IBOutlet UITextField *eventAddress2;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDateTime;

@end

@implementation CreateEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//event creation information to Parse
- (IBAction)submitEventOnButtonTapped:(UIButton *)sender
{
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"sport"] = self.eventSport.text;
    event[@"title"] = self.eventName.text;
    event[@"address"] = self.eventAddress.text;
    event[@"date"] = self.eventDateTime.date;
    [event saveInBackground];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.eventSport.text = nil;
    self.eventName.text = nil;
    self.eventAddress.text = nil;
    self.eventAddress2.text = nil;
    //self.eventDateTime.date = nil;
}

@end
