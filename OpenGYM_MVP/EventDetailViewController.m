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
    PFObject *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"myGames"];
    [relation addObject:self.eventObject];
    [user saveInBackground];
    
    int playersNeeded = [self.eventObject[@"playersNeeded"] intValue];
    int playersRegistered = [self.eventObject[@"playersRegistered"]intValue];
    
    playersNeeded--;
    playersRegistered++;
    
    self.eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
    self.eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
    [self.eventObject saveInBackground];
    
    [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
}

@end
