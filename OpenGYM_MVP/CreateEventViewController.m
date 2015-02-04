//
//  CreateEventViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/12/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "CreateEventViewController.h"

@interface CreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sportTextField;

@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPlayersLabel;
@property (weak, nonatomic) IBOutlet UIView *datePickerOverlayView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedController;
@property NSString *eventGender;

@end

@implementation CreateEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationTextField.text = nil;
    self.dateTimeTextField.text = nil;
    self.descriptionTextField.text = nil;
    
}

-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)pickDateAndTimeOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerOverlayView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 95, self.view.frame.size.width, 425);
    }];
}

- (IBAction)saveDateAndTimeOnButtonTapped:(UIButton *)sender
{
    self.dateTimeTextField.text = [NSString stringWithFormat:@"%@", self.datePicker.date];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.datePickerOverlayView.frame = CGRectMake(600, 600, 5, 5);
    }];
}

- (IBAction)addPlayersOnButtonTapped:(UIButton *)sender
{
    if([self.numberOfPlayersLabel.text intValue] >= 0)
    {
        int players = [self.numberOfPlayersLabel.text intValue];
        players++;
        self.numberOfPlayersLabel.text = [NSString stringWithFormat:@"%d", players];
    }
}

- (IBAction)subtractPlayersOnButtonTapped:(UIButton *)sender
{
    if([self.numberOfPlayersLabel.text intValue] > 0)
    {
        int players = [self.numberOfPlayersLabel.text intValue];
        players--;
        self.numberOfPlayersLabel.text = [NSString stringWithFormat:@"%d", players];
    }
}

- (IBAction)genderSelectedOnButtonTapped:(UISegmentedControl *)sender
{
    if(self.genderSegmentedController.selectedSegmentIndex == 0)
    {
        self.eventGender = @"Male";
    }
    else if(self.genderSegmentedController.selectedSegmentIndex == 1)
    {
        self.eventGender = @"Female";
    }
    else if(self.genderSegmentedController.selectedSegmentIndex == 2)
    {
        self.eventGender = @"Co-Ed";
    }
}

- (IBAction)createEventOnButtonTapped:(UIButton *)sender
{
    PFObject *event = [PFObject objectWithClassName:@"Event"];
    event[@"sport"] = self.sportTextField.text;
    event[@"location"] = self.locationTextField.text;
    event[@"date"] = self.dateTimeTextField.text;
    event[@"description"] = self.descriptionTextField.text;
    event[@"players"] = self.numberOfPlayersLabel.text;
    event[@"gender"] = self.eventGender;
    [event saveInBackground];
    
    [self performSegueWithIdentifier:@"mapSegueID" sender:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.locationTextField.text = nil;
    self.dateTimeTextField.text = nil;
    self.descriptionTextField.text = nil;
}

@end
