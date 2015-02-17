//
//  EventDetailViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MyGamesViewController.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *detailSportImage;
@property (weak, nonatomic) IBOutlet UIImageView *detailGenderImage;
@property (weak, nonatomic) IBOutlet UITextView *detailMembersGoingTextView;

@property NSMutableArray *usersRegisteredArray;
@property NSMutableString *usersString;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set bools to false by default
    self.userAlreadyRegistered = false;
    self.eventFull = false;
    
    self.usersRegisteredArray = [NSMutableArray new];
    
    PFRelation *usersToEvents = [self.eventObject relationForKey:@"registeredUsers"];
    PFQuery *userQuery = [usersToEvents query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        NSString *string = @"";
        
        for (PFUser *registeredUser in objects)
        {
            [self.usersRegisteredArray addObject:registeredUser.username];
        }
        
        for (int i = 0; i < self.usersRegisteredArray.count; i++)
        {
            string = [string stringByAppendingString:self.usersRegisteredArray[i]];
        }
        
        self.detailMembersGoingTextView.text = string;

    }];
    
    if([[self.eventObject objectForKey:@"sport"] isEqualToString:@"Basketball"])
    {
        self.detailSportImage.image = [UIImage imageNamed:@"OGsportbasketballICON"];
    }
    else if([[self.eventObject  objectForKey:@"sport"] isEqualToString:@"Baseball"])
    {
        self.detailSportImage.image  = [UIImage imageNamed:@"OGsportbaseballICON"];
    }
    else if([[self.eventObject  objectForKey:@"sport"] isEqualToString:@"Tennis"])
    {
        self.detailSportImage.image  = [UIImage imageNamed:@"OGsporttennisICON"];
    }
    else if([[self.eventObject  objectForKey:@"sport"] isEqualToString:@"Soccer"])
    {
        self.detailSportImage.image  = [UIImage imageNamed:@"OGsportsoccerICON"];
    }
    else if([[self.eventObject  objectForKey:@"sport"] isEqualToString:@"Football"])
    {
        self.detailSportImage.image  = [UIImage imageNamed:@"OGsportfootballICON"];
    }
    
    if ([[self.eventObject objectForKey:@"gender"] isEqualToString:@"Male"])
    {
        self.detailGenderImage.image = [UIImage imageNamed:@"maleicon.png"];
    }
    else if ([[self.eventObject objectForKey:@"gender"] isEqualToString:@"Female"])
    {
        self.detailGenderImage.image = [UIImage imageNamed:@"femaleicon.png"];
    }
    else if ([[self.eventObject objectForKey:@"gender"] isEqualToString:@"Co-Ed"])
    {
        self.detailGenderImage.image = [UIImage imageNamed:@"co-edicon.png"];
    }
    
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
    //set up current user and PFRelation
    PFUser *user = [PFUser currentUser];
    PFRelation *usersToEvents = [self.eventObject relationForKey:@"registeredUsers"];
    
    //check if current user is already registered for the selected event
    PFQuery *userQuery = [usersToEvents query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
        for (PFUser *usersRegistered in objects)
        {
            int playersNeeded = [self.eventObject[@"playersNeeded"] intValue];
            int playersRegistered = [self.eventObject[@"playersRegistered"]intValue];
            
            if ([usersRegistered.username isEqualToString:user.username])
            {
                self.userAlreadyRegistered = true;
            }
            else if (playersNeeded < 1)
            {
                self.eventFull = true;
            }
            
            //check which UIAlert needs to be presented
            if(self.userAlreadyRegistered && !self.eventFull)
            {
                UIAlertView *userAlreadyRegisteredAlert = [[UIAlertView alloc] initWithTitle:@"Stop!!!" message:@"You're already registered for this event." delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
                userAlreadyRegisteredAlert.tag = 1;
                [userAlreadyRegisteredAlert show];
            }
            else if(self.eventFull && !self.userAlreadyRegistered)
            {
                UIAlertView *eventFullAlert = [[UIAlertView alloc] initWithTitle:@"Sorry..." message:@"This event is already full." delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
                eventFullAlert.tag = 2;
                [eventFullAlert show];
            }
            else if(!self.userAlreadyRegistered && !self.eventFull)
            {
                playersNeeded--;
                playersRegistered++;
                
                self.eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
                self.eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
                [self.eventObject saveInBackground];
                
                PFRelation *eventsToUsers = [user relationForKey:@"myEvents"];
                [eventsToUsers addObject:self.eventObject];
                [user saveInBackground];
                
                [usersToEvents addObject:user];
                [self.eventObject saveInBackground];
                
                [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
            }
//            else if (self.userAlreadyRegistered && self.eventFull)
//            {
//                UIAlertView *userAlreadyRegisteredAlert = [[UIAlertView alloc] initWithTitle:@"Hold Up!" message:@"Then event is full and you are already registered!" delegate:self cancelButtonTitle:@"Back To Map" otherButtonTitles:nil];
//                userAlreadyRegisteredAlert.tag = 3;
//                [userAlreadyRegisteredAlert show];
//            }

        }
    }];
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
