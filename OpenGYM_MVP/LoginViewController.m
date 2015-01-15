//
//  LoginViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <TwitterKit/TwitterKit.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //button customization
    _btn.layer.borderColor = [UIColor whiteColor].CGColor;
    _btn.layer.borderWidth = 2;
    _btn.layer.cornerRadius = 5;
    
    //Twitter login
    TWTRLogInButton* logInButton =  [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error)
    {
        if (session)
        {
            NSLog(@"signed in as %@", [session userName]);
            [self performSegueWithIdentifier:@"loginSegueID" sender:self];

        } else{
            NSLog(@"error: %@", [error localizedDescription]);
        }
                                     }];
    logInButton.frame = CGRectMake(75, 525, 215, 40);
    [self.view addSubview:logInButton];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

//dismiss keyboard on touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_loginUsernameInput resignFirstResponder];
    [_loginPasswordInput resignFirstResponder];
}

//sign in method
- (IBAction)singInOnButtonTapped:(UIButton*)sender
{
    //Parse User query
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
             UIAlertView *loginErrorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Your username or password are incorrect. Please re-enter." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
             [loginErrorAlert show];
         }
     }];
}

//keep me signed in code, working and tested
-(void)viewDidAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    if(user.username != nil)
    {
        [self performSegueWithIdentifier:@"loginSegueID" sender:self];
    }
}

//password overlay animation
- (IBAction)forgotPasswordOnButtonTapped:(UIButton *)sender
{
    self.passwordRecoveryOverlay.frame = self.view.frame;
}

//Facebook SDK logging in segueing into the app
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"logged in");
    [self performSegueWithIdentifier:@"loginSegueID" sender:self];
}

@end
