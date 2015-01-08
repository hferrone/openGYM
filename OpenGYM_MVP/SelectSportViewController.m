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

@end

@implementation SelectSportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sportSelectButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _sportSelectButton.layer.borderWidth = 2.0;
    _sportSelectButton.layer.cornerRadius = 100;
}

- (IBAction)logout:(UIButton *)sender
{
    [PFUser logOut];
}

@end
