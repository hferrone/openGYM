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
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImageView;

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:@"dashboardPic"];
    UIImage *ratingsViewPic = [UIImage imageWithData:imageData];
    self.ratingsImageView.image = ratingsViewPic;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
