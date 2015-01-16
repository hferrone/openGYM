//
//  SlideOutViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/16/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "SlideOutViewController.h"

@interface SlideOutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation SlideOutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

@end
