//
//  EventDetailViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MyGamesViewController.h"

@interface EventDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)joinEventOnButtonTapped:(UIButton *)sender
{
    //set bool to false by default
    self.userAlreadyRegistered = false;
    
    //set up current user and PFRelation
    PFUser *user = [PFUser currentUser];
    PFRelation *usersToEvents = [self.eventObject relationForKey:@"usersRegistered"];
    
    //check if current user is already registered for the selected event
    PFQuery *userQuery = [usersToEvents query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        for (PFUser *usersRegistered in objects)
        {
            if ([usersRegistered.username isEqualToString:user.username])
            {
                self.userAlreadyRegistered = true;
                NSLog(@"You're already registered!");
            }
        }
    }];
    
    //if user is not registered, add user to selected event and event to current user
    if (!self.userAlreadyRegistered)
    {
        int playersNeeded = [self.eventObject[@"playersNeeded"] intValue];
        int playersRegistered = [self.eventObject[@"playersRegistered"]intValue];
        
        if (playersNeeded > 0)
        {
            playersNeeded--;
            playersRegistered++;
            
            self.eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
            self.eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
            [self.eventObject saveInBackground];
        }
        else{
            NSLog(@"Event is full");
        }
        
        PFRelation *eventsToUsers = [user relationForKey:@"myGames"];
        [eventsToUsers addObject:self.eventObject];
        [user saveInBackground];
        
        [usersToEvents addObject:user];
        [self.eventObject saveInBackground];
        
        [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
    }
}

@end
