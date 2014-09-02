//
//  NBSettingsAddModuleSemestersTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/14/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBSettingsAddModuleSemestersTableViewController.h"
#import "NBSettingsAddModuleModulesTableViewController.h"

@interface NBSettingsAddModuleSemestersTableViewController ()

@end

@implementation NBSettingsAddModuleSemestersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"semesterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. Semester", indexPath.row + 1];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"courseListSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NBSettingsAddModuleModulesTableViewController *nextView = segue.destinationViewController;
    nextView.semester = (int)self.tableView.indexPathForSelectedRow.row + 1;
}

@end
