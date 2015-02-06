//
//  RevealViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/16/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "RevealViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RevealViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dashboardProfilePic;

@end

@implementation RevealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.userFullNameLabel.text = user.username;
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)shareAppOnButtonTapped:(UIButton *)sender
{
    NSURL *shareURL = [NSURL URLWithString:@"www.rottentomatoes.com"];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
