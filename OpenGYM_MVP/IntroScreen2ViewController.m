//
//  IntroScreen2ViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 2/4/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "IntroScreen2ViewController.h"

@interface IntroScreen2ViewController ()

@end

@implementation IntroScreen2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSegueWithIdentifier:@"intro2Segue" sender:self];
}

@end
