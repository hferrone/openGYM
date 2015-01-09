//
//  PasswordRecoveryViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/8/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "PasswordRecoveryViewController.h"
#import <Parse/Parse.h>

@interface PasswordRecoveryViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordRecoveryEmail;

@end

@implementation PasswordRecoveryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordRecoveryEmail resignFirstResponder];
}

- (IBAction)recoveryPasswordOnButtonTapped:(UIButton *)sender
{
    [PFUser requestPasswordResetForEmailInBackground:_passwordRecoveryEmail.text block:^(BOOL succeeded, NSError *error)
    {
       if(error)
       {
           UIAlertView *emptyFieldsAlert = [[UIAlertView alloc] initWithTitle:@"Stop!!!" message:@"Invalid email, please re-enter your email." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
           [emptyFieldsAlert show];
       }
       else{
           [self performSegueWithIdentifier:@"passwordRecoverySuccessSegueID" sender:self];
       }
    }];
}

@end
