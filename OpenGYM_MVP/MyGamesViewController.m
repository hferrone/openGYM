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
#import "EventDetailViewController.h"

@interface MyGamesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *myGamesArray;
@property NSString *timeCountdownString;
@property PFObject *eventObject;

@end

@implementation MyGamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self queryMyGames];
}

-(void)queryMyGames
{
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationForKey:@"myEvents"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.myGamesArray = [[NSMutableArray alloc] initWithArray:objects];
         
         for (PFObject *object in self.myGamesArray)
         {
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"YYYY-MM-dd, h:mm"];
             NSDate *startingDate = [dateFormatter dateFromString:object[@"dateComparison"]];
             NSDate *endingDate = [NSDate date];
             
             NSCalendar *calendar = [NSCalendar currentCalendar];
             NSUInteger unitFlags = NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
             NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:endingDate toDate:startingDate options:0];
             
             NSInteger days     = [dateComponents day];
             NSInteger hours    = [dateComponents hour];
             NSInteger minutes  = [dateComponents minute];
             
             if (days < 1 && hours <= 24 && minutes <= 60)
             {
                 self.timeCountdownString = [NSString stringWithFormat:@"%ld hrs %ld min", (long)hours, (long)minutes];
             }
             else{
                 self.timeCountdownString = [NSString stringWithFormat:@"%@", object[@"dateComparison"]];
             }
         }

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
    cell.gameFeedTimeLabel.text = self.timeCountdownString;
    cell.gameFeedPlayersLabel.text = [event objectForKey:@"playersNeeded"];
    
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
    PFUser *user = [PFUser currentUser];
    
    PFRelation *eventsToUsers = [user relationForKey:@"myEvents"];
    [eventsToUsers removeObject:[self.myGamesArray objectAtIndex:indexPath.row]];
    [user saveInBackground];
    
    PFRelation *usersToEvents = [[self.myGamesArray objectAtIndex:indexPath.row] relationForKey:@"registeredUsers"];
    [usersToEvents removeObject:user];
    [[self.myGamesArray objectAtIndex:indexPath.row] saveInBackground];
    
    //subtract from players registered and add back to players needed
    PFObject *eventObject = [self.myGamesArray objectAtIndex:indexPath.row];
    
    int playersNeeded = [eventObject[@"playersNeeded"] intValue];
    int playersRegistered = [eventObject[@"playersRegistered"]intValue];
    
    playersNeeded++;
    playersRegistered--;
    
    eventObject[@"playersNeeded"] = [NSString stringWithFormat:@"%d", playersNeeded];
    eventObject[@"playersRegistered"] = [NSString stringWithFormat:@"%d", playersRegistered];
    [eventObject saveInBackground];
    
    [self.myGamesArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

-(void)tableView:(UITableViewCell *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.eventObject = [self.myGamesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"eventDetailSegueID" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"eventDetailSegueID"])
    {
        EventDetailViewController *evc = segue.destinationViewController;
        evc.eventObject = self.eventObject;
    }
}

@end
