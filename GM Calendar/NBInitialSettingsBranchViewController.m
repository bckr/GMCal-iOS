//
//  NBInitialSettingsBranchViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsBranchViewController.h"

@interface NBInitialSettingsBranchViewController ()

- (NSArray *)engineeringBranches;
- (NSArray *)informaticsBranches;
- (NSDictionary *)branchAbbreviations;

@end

@implementation NBInitialSettingsBranchViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.branchesToDisplay objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"Bachelor" : @"Master";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BranchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.branchesToDisplay objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    return cell;
}

- (NSArray *)engineeringBranches {
    NSArray *engineeringBranchesBachelor = @[@"Elektronik", @"Maschinenbau Schwerpunkt Fertigung", @"Automatisierungstechnik", @"Wirtschaftsingenieurwesen", @"Maschinenbau", @"Ingenieurwissenschaftliches Grundstudium", @"Informatik-Ingenieur", @"Wirtschaftsingenieur Elektrotechnik", @"Wirtschaftsingenieur Maschinenbau", @"Maschinenbau Informatik", @"Maschinenbau Konstruktion"];
    NSArray *engineeringBranchesMaster = @[@"Master Produktdesign und Prozessentwicklung"];
    return @[engineeringBranchesBachelor, engineeringBranchesMaster];
}

- (NSArray *)informaticsBranches {
    NSArray *informaticsBranchesBachelor = @[@"Wirtschaftsinformatik", @"Medieninformatik", @"Technische Informatik", @"Allgemeine Informatik"];
    NSArray *informaticsBranchesMaster = @[@"Automation and IT Master", @"Medieninformatik-Master", @"Informatik-Master", @"Web Science"];
    return @[informaticsBranchesBachelor, informaticsBranchesMaster];
}

- (NSDictionary *)branchAbbreviations {
    return @{@"Wirtschaftsinformatik" : @"WI", @"Medieninformatik" : @"MI", @"Technische Informatik" : @"TI", @"Allgemeine Informatik" : @"AI", @"Maschinenbau Schwerpunkt Fertigung" : @"MMF", @"Elektronik" : @"EEL", @"Automatisierungstechnik" : @"EAT", @"Wirtschaftsingenieurwesen" : @"MW", @"Maschinenbau" : @"MM", @"Ingenieurwissenschaftliches Grundstudium" : @"BB", @"Informatik-Ingenieur" : @"II", @"Wirtschaftsingenieur Elektrotechnik" : @"MWE", @"Wirtschaftsingenieur Maschinenbau" : @"MWM", @"Maschinenbau Informatik" : @"MMII", @"Maschinenbau Konstruktion" : @"MMK", @"Master Produktdesign und Prozessentwicklung" : @"PPDM", @"Automation and IT Master" : @"AITM", @"Medieninformatik-Master" : @"MMI", @"Informatik-Master" : @"IM", @"Web Science" : @"WEB"};
}

- (NSArray *)branchesForMajor {
    return @[self.informaticsBranches, self.engineeringBranches];
}

#pragma mark - Branch Segue

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *branch = [self.branchAbbreviations valueForKey:[[self.branchesToDisplay objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    NSLog(@"Selected branch: %@", branch);
    [[NSUserDefaults standardUserDefaults] setObject:branch forKey:@"branch"];
    [self performSegueWithIdentifier:@"semesterSegue" sender:self];
}

@end
