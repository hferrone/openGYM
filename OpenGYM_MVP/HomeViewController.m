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

@property NSArray *storedEvents;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *sportFilterSelected;

@property PFObject *eventObject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

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
         self.storedEvents = [[NSArray alloc] initWithArray:objects];
         [self.tableView reloadData];
     }];
}

-(void)parseDataQueryWithFilter: (NSString*) filter
{
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"sport" equalTo:filter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         self.storedEvents = [[NSArray alloc] initWithArray:objects];
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
    
    homeCell.cellTitleLabel.text = [event objectForKey:@"description"];
    homeCell.cellTimeLabel.text = [event objectForKey:@"date"];
    homeCell.cellNumberPlayersLabel.text = [event objectForKey:@"players"];
    
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
