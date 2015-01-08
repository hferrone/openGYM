//
//  LoginViewController.h
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameInput;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordInput;
@property (weak, nonatomic) IBOutlet UIView *passwordRecoveryOverlay;

@end
