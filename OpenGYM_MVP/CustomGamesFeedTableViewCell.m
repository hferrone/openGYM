//
//  CustomGamesFeedTableViewCell.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/26/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "CustomGamesFeedTableViewCell.h"

@implementation CustomGamesFeedTableViewCell

@synthesize gameFeedImage = _gameFeedImage;
@synthesize gameFeedPlayersLabel = _gameFeedPlayersLabel;
@synthesize gameFeedTimeLabel = _gameFeedTimeLabel;
@synthesize gameFeedTitleLabel = _gameFeedTitleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
