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
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *myGamesArray;

@end

@implementation MyGamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryMyGames];
        
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
    }
}

-(void)queryMyGames
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"myGames"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.myGamesArray = [[NSMutableArray alloc] initWithArray:objects];
         [self.tableView reloadData];
     }];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myGamesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomGamesFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gamesCellID"];
    PFObject *event = [self.myGamesArray objectAtIndex:indexPath.row];
    
    cell.gameFeedTitleLabel.text = [event objectForKey:@"title"];
    cell.gameFeedTimeLabel.text = [event objectForKey:@"time"];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    PFObject *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"myGames"];
    [relation removeObject:[self.myGamesArray objectAtIndex:indexPath.row]];
    [user saveInBackground];
    
    [self.myGamesArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
