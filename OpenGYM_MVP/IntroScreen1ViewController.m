//
//  IntroScreen1ViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 2/4/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "IntroScreen1ViewController.h"

@interface IntroScreen1ViewController ()

@end

@implementation IntroScreen1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSegueWithIdentifier:@"intro1Segue" sender:self];
}

@end
