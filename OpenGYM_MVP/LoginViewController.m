//
//  LoginViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) NSString *forgotPasswordEmail;
@property (weak, nonatomic) IBOutlet UITextField *passwordRecoveryEmail;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn.layer.borderWidth = 2;
    _btn.layer.cornerRadius = 5;
}

-(BOOL)prefersStatusBarHidden
{
    return true;
}
- (IBAction)singInOnButtonTapped:(UIButton*)sender
{
    [PFUser logInWithUsernameInBackground:_loginUsernameInput.text password:_loginPasswordInput.text block:^(PFUser *user, NSError *error)
     {
         if(!error)
         {
             NSLog(@"User logged in");
             [self performSegueWithIdentifier:@"loginSegueID" sender:self];
             
             _loginUsernameInput.text = nil;
             _loginPasswordInput.text = nil;
         }
         else{
             UIAlertView *loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Error logging in" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
             [loginErrorAlert show];
         }
     }];
}

-(void)viewDidAppear:(BOOL)animated
{
    //keep me signed in code, working and tested
    PFUser *user = [PFUser currentUser];
    if(user.username != nil)
    {
        [self performSegueWithIdentifier:@"loginSegueID" sender:self];
    }
}

- (IBAction)forgotPasswordOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.passwordRecoveryOverlay.frame = self.view.frame;
    }];
}

@end
