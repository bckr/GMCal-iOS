//
//  NBInitialSettingsMajorTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsMajorTableViewController.h"
#import "NBInitialSettingsBranchViewController.h"

@interface NBInitialSettingsMajorTableViewController ()

@end

@implementation NBInitialSettingsMajorTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.majors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MajorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
    cell.textLabel.text = [self.majors objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSArray *)majors {
    return @[@"Informatik", @"Ingenieurwesen"];
}

#pragma mark - Branch Segue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *major = [self.majors objectAtIndex:indexPath.row];
    NSLog(@"Selected major: %@", major);
    [[NSUserDefaults standardUserDefaults] setObject:major forKey:@"major"];
    [self performSegueWithIdentifier:@"branchSegue" sender:self];
    [self setEditing:NO animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NBInitialSettingsBranchViewController *nextView = segue.destinationViewController;
    unsigned index = self.tableView.indexPathForSelectedRow.row;
    nextView.branchesToDisplay = [nextView.branchesForMajor objectAtIndex:index];
}

@end
