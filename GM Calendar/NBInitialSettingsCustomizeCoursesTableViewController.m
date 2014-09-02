//
//  NBInitialSettingsCustomizeCoursesTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 3/5/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsCustomizeCoursesTableViewController.h"
#import "AppDelegate.h"
#import "NBClass.h"
#import "NBClass+Management.h"
#import "NBCourse.h"
#import "NBCourseCompactCell.h"
#import "NBSchedule.h"

@implementation NBInitialSettingsCustomizeCoursesTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.allowsMultipleSelection = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    if (animated) {
        if ([self.delegate respondsToSelector:@selector(didSelectSeminars:)]) {
            [self.delegate didSelectCourses:[NSSet setWithSet:self.selectedCourses]];
        }
    }
}

- (NSMutableSet *)selectedCourses {
    if (!_selectedCourses) _selectedCourses = [NSMutableSet setWithArray:self.classes];
    return _selectedCourses;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedCourses containsObject:[self.classes objectAtIndex:indexPath.row]]) {
        [self.selectedCourses removeObject:[self.classes objectAtIndex:indexPath.row]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.selectedCourses addObject:[self.classes objectAtIndex:indexPath.row]];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.classes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"courseCell";
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

#pragma mark - Helper methods

- (void)configureCell:(NBCourseCompactCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBClass *currentClass = [self.classes objectAtIndex:indexPath.row];
    cell.courseNameLabel.text = currentClass.name;
    NSDateComponents *start = [NBSchedule timeForPeriod:[currentClass.start intValue]];
    NSDateComponents *end = [NBSchedule timeForPeriod:([currentClass.start intValue] + 1)];
    NSString *day = [NBSchedule dayForPeriod:[currentClass.day intValue]];
    cell.courseLecturers.text = [NSString stringWithFormat:@"%@: %02d:%02d - %02d:%02d", day, start.hour, start.minute, end.hour, end.minute];
    cell.courseTypeIndicatorColor = [NBSchedule colorForTypeOfClass:currentClass];
    
    if ([self.selectedCourses containsObject:[self.classes objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end

