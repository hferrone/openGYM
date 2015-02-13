//
//  HomeViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/17/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "CustomHomeFeedTableViewCell.h"
#import "EventDetailViewController.h"

#import <Parse/Parse.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *storedEvents;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *sportFilterSelected;

@property PFObject *eventObject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property(readonly) NSTimeInterval timeIntervalSinceNow;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseDataQueryAll];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( rightRevealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)parseDataQueryAll
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.storedEvents = [[NSMutableArray alloc] initWithArray:objects];
         NSLog(@"%@", self.storedEvents);
         
         for (PFObject *object in self.storedEvents)
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
             
             if (days >= 0 && hours >= 0 && minutes >= 0)
             {
                 [self.storedEvents removeObject:object];
             }
             
             NSString *countdownText = [NSString stringWithFormat:@"%ld Days %ld Hours %ld Minutes", (long)days, (long)hours, (long)minutes];
             NSLog(@"%@", countdownText);
         }
         
         [self.tableView reloadData];
     }];
}

-(void)parseDataQueryWithFilter: (NSString*) filter
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"sport" equalTo:filter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.storedEvents = [[NSMutableArray alloc] initWithArray:objects];
         [self.tableView reloadData];
     }];
}

//hide status bar per design
-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)allEventsFilter:(UIButton *)sender
{
    [self parseDataQueryAll];
}

- (IBAction)basketballFilter:(UIButton *)sender
{
    self.sportFilterSelected = @"Basketball";
    [self parseDataQueryWithFilter:self.sportFilterSelected];
}

- (IBAction)soccerFilter:(UIButton *)sender
{
    self.sportFilterSelected = @"Soccer";
    [self parseDataQueryWithFilter:self.sportFilterSelected];
}

- (IBAction)baseballFilter:(UIButton *)sender
{
    self.sportFilterSelected = @"Baseball";
    [self parseDataQueryWithFilter:self.sportFilterSelected];
}

- (IBAction)tennisFilter:(UIButton *)sender
{
    self.sportFilterSelected = @"Tennis";
    [self parseDataQueryWithFilter:self.sportFilterSelected];
}

- (IBAction)footballFilter:(UIButton *)sender
{
    self.sportFilterSelected = @"Football";
    [self parseDataQueryWithFilter:self.sportFilterSelected];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.storedEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomHomeFeedTableViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"homeCellID"];
    PFObject *event = [self.storedEvents objectAtIndex:indexPath.row];
    
    homeCell.cellTitleLabel.text = [event objectForKey:@"title"];
    homeCell.cellTimeLabel.text = [event objectForKey:@"date"];
    homeCell.cellNumberPlayersLabel.text = [event objectForKey:@"players"];
    
    if([[event objectForKey:@"sport"] isEqualToString:@"Basketball"])
    {
        homeCell.cellImageView.image = [UIImage imageNamed:@"OGsportbasketballICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Baseball"])
    {
        homeCell.cellImageView.image = [UIImage imageNamed:@"OGsportbaseballICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Tennis"])
    {
        homeCell.cellImageView.image = [UIImage imageNamed:@"OGsporttennisICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Soccer"])
    {
        homeCell.cellImageView.image = [UIImage imageNamed:@"OGsportsoccerICON"];
    }
    else if([[event objectForKey:@"sport"] isEqualToString:@"Football"])
    {
        homeCell.cellImageView.image = [UIImage imageNamed:@"OGsportfootballICON"];
    }

    return homeCell;
}

-(void)tableView:(UITableViewCell *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.eventObject = [self.storedEvents objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"eventDetailSegueID" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventDetailViewController *evc = segue.destinationViewController;
    evc.eventObject = self.eventObject;
}

@end
