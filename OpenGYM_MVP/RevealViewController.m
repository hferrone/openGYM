//
//  RevealViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/16/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "RevealViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RevealViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dashboardProfilePic;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) UIImage *dashboardPicture;
@property (weak, nonatomic) IBOutlet UIView *imagePickerPopoverView;

@end

@implementation RevealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *user = [PFUser currentUser];
    self.userFullNameLabel.text = user.username;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *imageData = [defaults dataForKey:@"dashboardPic"];
    UIImage *dashboardPic = [UIImage imageWithData:imageData];
    self.dashboardProfilePic.image = dashboardPic;
}

- (IBAction)selectImageOnButtonTapped:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(self.view.frame.origin.x + 100, self.view.frame.origin.y + 150, self.imagePickerPopoverView.frame.size.width, self.imagePickerPopoverView.frame.size.height);
    }];
}

- (IBAction)selectImageFromPhotoLibrary:(UIButton*)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
    
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)selectImageFromCamera:(UIButton*)sender
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
    self.dashboardPicture = info[UIImagePickerControllerOriginalImage];
    [self.dashboardProfilePic setImage:self.dashboardPicture];
    
    NSData *savedProfilePicture = UIImageJPEGRepresentation(self.dashboardPicture, 10);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:savedProfilePicture forKey:@"dashboardPic"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)shareAppOnButtonTapped:(UIButton *)sender
{
    NSURL *shareURL = [NSURL URLWithString:@"www.rottentomatoes.com"];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[shareURL] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        self.imagePickerPopoverView.frame = CGRectMake(600, 600, 5, 5);
    }];
}

@end
