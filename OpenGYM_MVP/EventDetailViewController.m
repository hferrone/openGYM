//
//  EventDetailViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MyGamesViewController.h"

@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *eventDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *confirmedPlayersLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *remainingPlayersLabel;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventDetailTitle.title = self.eventObject[@"description"];
    
    //self.confirmedPlayersLabel.text = self.eventObject[@"players"];
    self.locationLabel.text = self.eventObject[@"location"];
    self.timeDateLabel.text = self.eventObject[@"date"];
    self.remainingPlayersLabel.text = self.eventObject[@"players"];
    
    self.remainingPlayersLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.remainingPlayersLabel.layer.borderWidth = 2;
    
    self.confirmedPlayersLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.confirmedPlayersLabel.layer.borderWidth = 2;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)joinEventOnButtonTapped:(UIButton *)sender
{
    self.eventObject[@"favorite"] = @"yes";
    [self.eventObject saveInBackground];
    
    [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
}

@end
