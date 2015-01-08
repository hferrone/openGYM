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
- (IBAction)recoveryPasswordOnButtonTapped:(UIButton *)sender
{
    [PFUser requestPasswordResetForEmailInBackground:_passwordRecoveryEmail.text];
}

@end
