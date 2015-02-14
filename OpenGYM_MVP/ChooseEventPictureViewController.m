//
//  ChooseEventPictureViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 2/12/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "ChooseEventPictureViewController.h"
#import "CreateEventViewController.h"

@interface ChooseEventPictureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *EventPicSelectedImageView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property UIImage *eventPicture;

@end

@implementation ChooseEventPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(BOOL)prefersStatusBarHidden
{
    return  YES;
}

- (IBAction)selectPhotoFromLibrary:(UIButton *)sender
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)selectPhotoFromCamera:(UIButton *)sender
{
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.eventPicture = info[UIImagePickerControllerOriginalImage];
    [self.EventPicSelectedImageView setImage:self.eventPicture];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backToCreateEvent"])
    {
        CreateEventViewController *cevc = segue.destinationViewController;
        cevc.eventImage = self.eventPicture;
    }
}

@end
