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
@property (weak, nonatomic) IBOutlet UIButton *recoverButton;


@end

@implementation PasswordRecoveryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.recoverButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.recoverButton.layer.borderWidth = 2;
    self.recoverButton.layer.cornerRadius = 5;
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

//dismiss keyboard on touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_passwordRecoveryEmail resignFirstResponder];
}

//Parse password recovery
- (IBAction)recoverPasswordOnButtonTapped:(UIButton *)sender
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
