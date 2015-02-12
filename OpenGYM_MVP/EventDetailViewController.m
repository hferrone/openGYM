//
//  EventDetailViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "EventDetailViewController.h"
#import "MyGamesViewController.h"

@interface EventDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *eventDetailTitle;

@property (weak, nonatomic) IBOutlet UILabel *confirmedPlayersLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingPlayersLabel;
@property NSMutableArray *myGamesArray;
@property (weak, nonatomic) IBOutlet UIButton *joinEventButton;
@property (weak, nonatomic) IBOutlet UITextView *eventDescription;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *eventDetailPictureView;
@property (weak, nonatomic) IBOutlet UIView *photoEventPopoverView;

@property UIImage *eventDetailPicture;

@end

@implementation EventDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.eventDetailTitle.title = self.eventObject[@"title"];
    
    self.locationLabel.text = self.eventObject[@"location"];
    self.timeDateLabel.text = [NSString stringWithFormat:@"%@ - %@", self.eventObject[@"date"], self.eventObject[@"time"]];
    self.remainingPlayersLabel.text = self.eventObject[@"playersNeeded"];
    self.confirmedPlayersLabel.text = self.eventObject[@"playersRegistered"];
    self.eventDescription.text = self.eventObject[@"description"];
    
    self.joinEventButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joinEventButton.layer.borderWidth = 1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:@"eventPic"];
    UIImage *eventPic = [UIImage imageWithData:imageData];
    self.eventDetailPictureView.image = eventPic;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)choosePhotoOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.photoEventPopoverView.frame = CGRectMake(self.view.frame.origin.x + 100, self.view.frame.origin.y + 150, self.photoEventPopoverView.frame.size.width, self.photoEventPopoverView.frame.size.height);
    }];
}

- (IBAction)selectPhotoFromLibrary:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.photoEventPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)selectPhotoFromCamera:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.photoEventPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.eventDetailPicture = info[UIImagePickerControllerOriginalImage];
    [self.eventDetailPictureView setImage:self.eventDetailPicture];
    
    NSData *savedEventPicture = UIImageJPEGRepresentation(self.eventDetailPicture, 10);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedEventPicture forKey:@"profilePic"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)joinEventOnButtonTapped:(UIButton *)sender
{
    PFObject *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"myGames"];
    [relation addObject:self.eventObject];
    [user saveInBackground];
    
    int playersNeeded = [self.eventObject[@"playersNeeded"] intValue];
    int playersRegistered = [self.eventObject[@"playersRegistered"]intValue];
    
    playersNeeded--;
    playersRegistered++;
    
    self.eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
    self.eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
    [self.eventObject saveInBackground];
    
    [self performSegueWithIdentifier:@"myGamesSegueID" sender:self];
}

@end
