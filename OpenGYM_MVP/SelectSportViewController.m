//
//  ViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "SelectSportViewController.h"

@interface SelectSportViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sportSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SelectSportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //button customization
    _sportSelectButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _sportSelectButton.layer.borderWidth = 2.0;
    _sportSelectButton.layer.cornerRadius = 100;
    
    _logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoutButton.layer.borderWidth = 2;
    _logoutButton.layer.cornerRadius = 5;
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

//logout for testing purposes (Facebook and Parse)
- (IBAction)logout:(UIButton *)sender
{
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    [PFUser logOut];
}

@end
