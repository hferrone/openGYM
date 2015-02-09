//
//  RatingsViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/17/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "RatingsViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface RatingsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation RatingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    PFUser *user = [PFUser currentUser];
    self.usernameLabel.text = user.username;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
