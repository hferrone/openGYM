//
//  SportSelectionTableViewController.m
//  OpenGYM_MVP
//
//  Created by Harrison Ferrone on 1/8/15.
//  Copyright (c) 2015 Harrison Ferrone. All rights reserved.
//

#import "SportSelectionTableViewController.h"

@interface SportSelectionTableViewController ()

@property NSArray *sports;

@end

@implementation SportSelectionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sports = @[@"Football", @"Soccer", @"Baseball", @"Tennis", @"Basketball"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sportSelectionCellID" forIndexPath:indexPath];
    cell.textLabel.text = _sports[0];
    
    return cell;
}

@end
