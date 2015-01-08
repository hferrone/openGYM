//
//  RegistrationViewController.h
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/6/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *registerUsernameInput;
@property (weak, nonatomic) IBOutlet UITextField *registerEmailInput;
@property (weak, nonatomic) IBOutlet UITextField *registerPasswordInput;

@end
