//
//  CalendarListViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 10/28/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "NBCalendarWeekViewController.h"
#import "NBCalendarDayViewController.h"
#import "NBClassDetailTableViewController.h"
#import "NBSchedule.h"
#import "NBClassCell.h"
#import "NBClass.h"
#import "NBCourse.h"
#import "NBClass+Management.h"
#import "AppDelegate.h"

@interface NBCalendarWeekViewController ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation NBCalendarWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Wochenansicht";
    [self setupGestures];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"classCell";
    NBClassCell *cell = (NBClassCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section {
    int period = [[[[self.fetchedResultsController sections] objectAtIndex:section] name] intValue];
    return [NBSchedule dayForPeriod:period];
}

#pragma mark - Fetched request

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Class" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *daySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES];
    NSSortDescriptor *startSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[daySortDescriptor, startSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.sectionKeyPath = @"day";
    
    return fetchRequest;
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NBClassDetailTableViewController *detailViewController = [segue destinationViewController];
    NBClass *selectedClass = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    detailViewController.currentClass = selectedClass;
}


#pragma mark Gestures

- (void)setupGestures {
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    gestureRecognizer.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        self.selectedIndexPath = indexPath;
        
        if (indexPath) {
            NBClass *selectedClass = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
            NSString *buttonTitle = [NSString stringWithFormat:@"%@ entfernen", selectedClass.typeString];
            NSString *sheetTitle = [NSString stringWithFormat:@"%@ entfernen?", selectedClass.typeString];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle
                                                                     delegate:self
                                                            cancelButtonTitle:@"Abbrechen"
                                                       destructiveButtonTitle:@"Modul entfernen"
                                                            otherButtonTitles:buttonTitle, nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showFromTabBar:self.tabBarController.tabBar];
        }
    }
}

#pragma mark Action Sheet delegation

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NBClass *selectedClass = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        NBCourse *courseToDelete = selectedClass.course;
        [self.managedObjectContext deleteObject:courseToDelete];
    }
    if (buttonIndex == 1) {
        NBClass *classToDelete = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        NBCourse *courseForSelectedClass = classToDelete.course;
        
        if ([courseForSelectedClass.classes count] > 1) {
            [self.managedObjectContext deleteObject:classToDelete];
        } else {
            // delete the enire course if no classes are left
            NBCourse *courseToDelete = classToDelete.course;
            [self.managedObjectContext deleteObject:courseToDelete];
        }
    }
}

#pragma mark - Helper methods

- (void)configureCell:(NBClassCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBClass *myClass = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.classNameLabel.text = myClass.name;
    cell.lecturerNameLabel.text = [[[myClass lecturers] allObjects] componentsJoinedByString:@", "];
    NSDateComponents *start = [NBSchedule timeForPeriod:[myClass.start intValue]];
    NSDateComponents *end = [NBSchedule timeForPeriod:[myClass endOfClass]];
    cell.classTime.text = [NSString stringWithFormat:@"%02ld:%02ld - %02ld:%02ld", (long)start.hour, (long)start.minute, (long)end.hour, (long)end.minute];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.classTypeIndicatorColor = [NBSchedule colorForTypeOfClass:myClass];
    cell.classTypeText = [myClass.type stringByPaddingToLength:1 withString:myClass.type startingAtIndex:0];
}

@end
