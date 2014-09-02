//
//  CalendarDayViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 10/28/12.
//  Copyright (c) 2012 Nils Becker. All rights reserved.
//

#import "NBCalendarDayViewController.h"
#import "NBCalendarWeekViewController.h"
#import "NBClassDetailTableViewController.h"
#import "NBSchedule.h"
#import "NBClassCell.h"
#import "NBClass.h"
#import "NBCourse.h"
#import "NBClass+Management.h"
#import "AppDelegate.h"
#import "NSDate+Week.h"
#import "UIColor+Hex.h"

@interface NBCalendarDayViewController ()
@property (nonatomic, strong) UILabel *emptyTableViewTextLabel;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation NBCalendarDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tagesansicht";
    [self setupEmptyTableViewLabel];
    [self setupGestures];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    if (!animated) {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = [super numberOfSectionsInTableView:tableView];
    self.emptyTableViewTextLabel.hidden = numberOfSections > 0;
    return numberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"classCell";
    NBClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Fetched resquest

- (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Class" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    int currentDay;
    
#if TARGET_IPHONE_SIMULATOR
    currentDay = 4;
#else
    currentDay = [[NSDate date] weekday];
#endif
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"day == %d", currentDay - 1];
    fetchRequest.predicate = fetchPredicate;
    
    self.sectionKeyPath = @"start";
    
    return fetchRequest;
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

- (void)setupEmptyTableViewLabel {
    UIView *backgroundView = self.tableView.backgroundView;
    int posX = (self.view.frame.size.width - 200) / 2;
    int posY = (self.view.frame.size.height / 2) - 100;
    
    self.emptyTableViewTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, 200, 0)];
    self.emptyTableViewTextLabel.text = @"Du hast heute keine Vorlesung. Genieße den freien Tag!";
    self.emptyTableViewTextLabel.backgroundColor = [UIColor clearColor];
    self.emptyTableViewTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.emptyTableViewTextLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTableViewTextLabel.textColor = [UIColor grayColor];
    self.emptyTableViewTextLabel.numberOfLines = 3;
    [self.emptyTableViewTextLabel sizeToFit];
    self.emptyTableViewTextLabel.hidden = YES;
    
    [self.tableView insertSubview:self.emptyTableViewTextLabel belowSubview:self.tableView];
    self.tableView.backgroundView = backgroundView;
}

#pragma mark Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NBClassDetailTableViewController *detailViewController = [segue destinationViewController];
    NBClass *selectedClass = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    detailViewController.currentClass = selectedClass;
}

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
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

@end
