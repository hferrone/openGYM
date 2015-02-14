//
//  EventDetailViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MyGamesViewController.h"

#import <Parse/Parse.h>

@interface EventDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *eventDetailTitle;

@property (weak, nonatomic) IBOutlet UILabel *confirmedPlayersLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingPlayersLabel;
@property NSMutableArray *myGamesArray;
@property (weak, nonatomic) IBOutlet UIButton *joinEventButton;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (weak, nonatomic) IBOutlet UIImageView *eventDetailPictureView;

@property UIImage *eventDetailPicture;

@property BOOL userAlreadyRegistered;
@property BOOL eventFull;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventDetailTitle.title = self.eventObject[@"title"];
    
    self.locationLabel.text = self.eventObject[@"location"];
    self.timeDateLabel.text = [NSString stringWithFormat:@"%@ - %@", self.eventObject[@"date"], self.eventObject[@"time"]];
    self.remainingPlayersLabel.text = self.eventObject[@"playersNeeded"];
    self.confirmedPlayersLabel.text = self.eventObject[@"playersRegistered"];
    self.eventDescription.text = self.eventObject[@"description"];
    
    self.joinEventButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joinEventButton.layer.borderWidth = 1;
    
    PFFile *imageFile = [self.eventObject objectForKey:@"eventPic"];
    
    if(imageFile != NULL)
    {
        [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            UIImage *thumbnailImage = [UIImage imageWithData:imageData];
            self.eventDetailPictureView.image = thumbnailImage;
            
        }];
    }
    else
    {
        self.eventDetailPictureView.image = [UIImage imageNamed:@"PASbackground.png"];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)joinEventOnButtonTapped:(UIButton *)sender
{
    //set bools to false by default
    self.userAlreadyRegistered = false;
    self.eventFull = false;
    
    //set up current user and PFRelation
    PFUser *user = [PFUser currentUser];
    PFRelation *usersToEvents = [self.eventObject relationForKey:@"usersRegistered"];
    
    //check if event is full
    int playersNeeded = [self.eventObject[@"playersNeeded"] intValue];
    int playersRegistered = [self.eventObject[@"playersRegistered"]intValue];
    
    if (playersNeeded < 1)
    {
        self.eventFull = true;
        
        UIAlertView *eventFullAlert = [[UIAlertView alloc] initWithTitle:@"Sorry..." message:@"This event is already full." delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
        eventFullAlert.tag = 2;
        [eventFullAlert show];
    }
    
    //check if current user is already registered for the selected event
    PFQuery *userQuery = [usersToEvents query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        for (PFUser *usersRegistered in objects)
        {
            if ([usersRegistered.username isEqualToString:user.username])
            {
                self.userAlreadyRegistered = true;
                
                UIAlertView *userAlreadyRegisteredAlert = [[UIAlertView alloc] initWithTitle:@"Stop!!!" message:@"You're already registered for this event." delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
                userAlreadyRegisteredAlert.tag = 1;
                [userAlreadyRegisteredAlert show];
            }
        }
    }];
    
    //if user is not registered, add user to selected event and event to current user
    if (!self.userAlreadyRegistered && !self.eventFull)
    {
        playersNeeded--;
        playersRegistered++;
        
        self.eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
        self.eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
        [self.eventObject saveInBackground];
        
        PFRelation *eventsToUsers = [user relationForKey:@"myGames"];
        [eventsToUsers addObject:self.eventObject];
        [user saveInBackground];
        
        [usersToEvents addObject:user];
        [self.eventObject saveInBackground];
        
        [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
    }
    
    //check if both event is full and user is already registered
    if (self.userAlreadyRegistered && self.eventFull)
    {
        UIAlertView *userAlreadyRegisteredAlert = [[UIAlertView alloc] initWithTitle:@"Hold Up!" message:@"Then event is full and you are already registered!" delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
        userAlreadyRegisteredAlert.tag = 3;
        [userAlreadyRegisteredAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == alertView.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"backToMapSegueID" sender:self];
    }
    else if(alertView.tag == 2 && buttonIndex == alertView.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"backToMapSegueID" sender:self];
    }
    else if(alertView.tag == 3 && buttonIndex == alertView.cancelButtonIndex)
    {
        [self performSegueWithIdentifier:@"backToMapSegueID" sender:self];
    }
}

@end
