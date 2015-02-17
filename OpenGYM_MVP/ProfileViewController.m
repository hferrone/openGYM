//
//  ProfileViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/16/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextView *profileTextView;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) UIImage *profilePicture;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAgeLabel;
@property (weak, nonatomic) IBOutlet UIView *imagePickerPopoverView;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.profileUsernameLabel.text = user.username;
    self.userAgeLabel.text = [NSString stringWithFormat:@"%@ years", user[@"age"]];
    self.userLocationLabel.text = user[@"location"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:@"profilePic"];
    UIImage *profilePic = [UIImage imageWithData:imageData];
    self.profileImageView.image = profilePic;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    PFUser *user = [PFUser currentUser];
    self.profileTextView.text = user[@"aboutme"];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)selectProfileImageOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = self.view.frame;
    }];
}

- (IBAction)selectImageFromPhotoLibrary:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)selectImageFromCamera:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profilePicture = info[UIImagePickerControllerOriginalImage];
    [self.profileImageView setImage:self.profilePicture];
    
    NSData *savedProfilePicture = UIImageJPEGRepresentation(self.profilePicture, 10);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedProfilePicture forKey:@"profilePic"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    PFUser *user = [PFUser currentUser];
    user[@"aboutme"] = self.profileTextView.text;
    [user saveInBackground];
    
    [self.profileTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
}

@end
