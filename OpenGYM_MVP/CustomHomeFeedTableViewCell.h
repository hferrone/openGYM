//
//  CustomHomeFeedTableViewCell.h
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/25/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomHomeFeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellNumberPlayersLabel;

@end
