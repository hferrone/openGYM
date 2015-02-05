//
//  MyGamesViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/17/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "MyGamesViewController.h"
#import "SWRevealViewController.h"
#import "CustomGamesFeedTableViewCell.h"

@interface MyGamesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property NSArray *favoritedGames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyGamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"favorite" equalTo:@"yes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        self.favoritedGames = [[NSArray alloc] initWithArray:objects];
        [self.tableView reloadData];
    }];
        
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoritedGames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomGamesFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gamesCellID"];
    PFObject *event = [self.favoritedGames objectAtIndex:indexPath.row];
    
    cell.gameFeedTitleLabel.text = [event objectForKey:@"description"];
    cell.gameFeedTimeLabel.text = [event objectForKey:@"date"];
    cell.gameFeedPlayersLabel.text = [event objectForKey:@"players"];
    
    if([[event objectForKey:@"sport"] isEqualToString:@"Basketball"])
    {
        cell.gameFeedImage.image = [UIImage imageNamed:@"OGsportbasketballICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Baseball"])
    {
        cell.gameFeedImage.image = [UIImage imageNamed:@"OGsportbaseballICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Tennis"])
    {
        cell.gameFeedImage.image = [UIImage imageNamed:@"OGsporttennisICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Soccer"])
    {
        cell.gameFeedImage.image = [UIImage imageNamed:@"OGsportsoccerICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Football"])
    {
        cell.gameFeedImage.image = [UIImage imageNamed:@"OGsportfootballICON"];
    }
    
    return cell;
}

@end
