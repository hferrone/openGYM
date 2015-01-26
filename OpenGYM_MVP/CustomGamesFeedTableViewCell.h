//
//  CustomGamesFeedTableViewCell.h
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/26/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGamesFeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gameFeedImage;
@property (weak, nonatomic) IBOutlet UILabel *gameFeedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameFeedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameFeedPlayersLabel;

@end
