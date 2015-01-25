//
//  CustomHomeFeedTableViewCell.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "CustomHomeFeedTableViewCell.h"

@implementation CustomHomeFeedTableViewCell

@synthesize cellImageView = _cellImageView;
@synthesize cellNumberPlayersLabel = _cellNumberPlayersLabel;
@synthesize cellTimeLabel = _cellTimeLabel;
@synthesize cellTitleLabel = _cellTitleLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinEventOnButtonTapped:(UIButton *)sender
{
    
}

@end
