//
//  RegistrationViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@end

@implementation RegistrationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.cornerRadius = 5;
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

//dismissing keyboard at touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_registerUsernameInput resignFirstResponder];
    [_registerEmailInput resignFirstResponder];
    [_registerPasswordInput resignFirstResponder];
}

//register new user method
- (IBAction)registerOnButtonTapped:(UIButton *)sender
{
    [self checkFieldCompletion];
}

//check for all fields being complete
-(void)checkFieldCompletion
{
    if ([_registerUsernameInput.text isEqualToString:@""] || [_registerEmailInput.text isEqualToString:@""] || [_registerPasswordInput.text isEqualToString:@""])
    {
        UIAlertView *emptyFieldsAlert = [[UIAlertView alloc] initWithTitle:@"Hold it" message:@"All fields must be filled out before we can complete your registration." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [emptyFieldsAlert show];
    }
    else {
        [self registerNewUser];
    }
}

//Parse user registration 
-(void)registerNewUser
{
    PFUser *newUser = [PFUser user];
    newUser.username = _registerUsernameInput.text;
    newUser.email = _registerEmailInput.text;
    newUser.password = _registerPasswordInput.text;
    newUser[@"age"] = _registerAge.text;
    newUser[@"location"] = _registerCityState.text;
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(!error)
        {
            NSLog(@"Registered!");
            [self performSegueWithIdentifier:@"registerSegueID" sender:self];
            
            _registerUsernameInput.text = nil;
            _registerEmailInput.text = nil;
            _registerPasswordInput.text = nil;
        }
        else{
            NSLog(@"Registration failed.");
        }
    }];
}

@end
