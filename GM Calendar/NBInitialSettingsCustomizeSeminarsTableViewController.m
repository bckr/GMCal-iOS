//
//  NBInitialSettingsCustomizeSeminarsTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 3/5/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsCustomizeSeminarsTableViewController.h"
#import "AppDelegate.h"
#import "NBClass.h"
#import "NBClass+Management.h"
#import "NBCourse.h"
#import "NBCourseCompactCell.h"
#import "NBSchedule.h"

@implementation NBInitialSettingsCustomizeSeminarsTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.allowsMultipleSelection = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    if (animated) {
        if ([self.delegate respondsToSelector:@selector(didSelectSeminars:)]) {
            [self.delegate didSelectSeminars:[NSSet setWithSet:self.selectedSeminars]];
        }
    }
}

- (NSMutableSet *)selectedSeminars {
    if (!_selectedSeminars) _selectedSeminars = [[NSMutableSet alloc] initWithCapacity:15];
    return _selectedSeminars;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedSeminars containsObject:[self.seminars objectAtIndex:indexPath.row]]) {
        [self.selectedSeminars removeObject:[self.seminars objectAtIndex:indexPath.row]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.selectedSeminars addObject:[self.seminars objectAtIndex:indexPath.row]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.seminars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"seminarCell";
    NBCourseCompactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark Helper methods

- (void)configureCell:(NBCourseCompactCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBClass *currentClass = [self.seminars objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = currentClass.name;
    NSDateComponents *start = [NBSchedule timeForPeriod:[currentClass.start intValue]];
    NSDateComponents *end = [NBSchedule timeForPeriod:([currentClass.start intValue] + 1)];
    NSString *day = [NBSchedule dayForPeriod:[currentClass.day intValue]];
    cell.courseLecturers.text = [NSString stringWithFormat:@"%@: %02d:%02d - %02d:%02d", day, start.hour, start.minute, end.hour, end.minute];
    cell.courseTypeIndicatorColor = [NBSchedule colorForTypeOfClass:currentClass];
    
    if ([self.selectedSeminars containsObject:[self.seminars objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

@end
