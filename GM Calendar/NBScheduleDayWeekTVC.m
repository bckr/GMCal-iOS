//
//  NBScheduleDayWeekTVC.m
//  GM Calendar
//
//  Created by Nils Becker on 20/12/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBScheduleDayWeekTVC.h"
#import "NBClassDetailTableViewController.h"
#import "NBSchedule.h"
#import "NBClassCell.h"
#import "NBClass.h"
#import "NBCourse.h"
#import "NBClass+Management.h"
#import "AppDelegate.h"
#import "NSDate+Week.h"
#import "UIColor+Hex.h"

@interface NBScheduleDayWeekTVC ()

@property (nonatomic, strong) UILabel *emptyTableViewTextLabel;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSFetchedResultsController *dayFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *weekFetchedResultsController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSegmentedControl;

@end

@implementation NBScheduleDayWeekTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
    [self setupEmptyTableViewLabel];
    [self setupGestures];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    if (!animated) {
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [super numberOfSectionsInTableView:tableView];
    self.emptyTableViewTextLabel.hidden = numberOfSections > 0;
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.viewSegmentedControl.selectedSegmentIndex == 0) return nil;
    int period = [[[[self.currentFetchedResultsController sections] objectAtIndex:section] name] intValue];
    return [NBSchedule dayForPeriod:period];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"classCell";
    NBClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NBClass *classAtIndexPath = [self.currentFetchedResultsController objectAtIndexPath:indexPath];
    NSString *classNameText = classAtIndexPath.name;
    NSUInteger numberOfLines = [self numberOfLinesForCourseNameLabelForText:classNameText];
    return 90 + ((numberOfLines - 1) * 20);
}

#pragma mark - Fetched resquest

- (NSFetchedResultsController *)dayFetchedResultsController
{
    if (_dayFetchedResultsController != nil) return _dayFetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Class" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:8];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    int currentDay;
    
#if TARGET_IPHONE_SIMULATOR
    currentDay = 4;
#else
    currentDay = [[NSDate date] weekday];
#endif
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"day == %d AND type IN %@", currentDay, [self classTypesToDisplay]];
    fetchRequest.predicate = fetchPredicate;
    
    NSString *sectionKeyPath = @"start";
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKeyPath cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.dayFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.dayFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _dayFetchedResultsController;
}

- (NSFetchedResultsController *)weekFetchedResultsController
{
    if (_weekFetchedResultsController != nil) return _weekFetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Class" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:8];
    
    NSSortDescriptor *daySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES];
    NSSortDescriptor *startSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[daySortDescriptor, startSortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"type IN %@", [self classTypesToDisplay]];
    
    NSString *sectionKeyPath = @"day";
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:sectionKeyPath cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.weekFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.weekFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _weekFetchedResultsController;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Class" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:8];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    int currentDay;
    
#if TARGET_IPHONE_SIMULATOR
    currentDay = 4;
#else
    currentDay = [[NSDate date] weekday];
#endif
    
    NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"day == %d AND type IN %@", currentDay, [self classTypesToDisplay]];
    fetchRequest.predicate = fetchPredicate;
    
    self.sectionKeyPath = @"start";

    return fetchRequest;
}

- (void)filterChanged
{
    switch (self.viewSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            int currentDay = [[NSDate date] weekday];
            self.currentFetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"day == %d AND type IN %@", currentDay, [self classTypesToDisplay]];
            break;
        }
        case 1:
            self.currentFetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"type IN %@", [self classTypesToDisplay]];
            break;
    }

    
	NSError *error = nil;
	if (![self.currentFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
}

#pragma mark - Helper methods

- (void)initialSetup
{
    self.navigationItem.title = @"Tagesansicht";
    
    // setup tab bar
    self.tabBarItem.image = [UIImage imageNamed:@"day.png"];
    self.tabBarItem.selectedImage = [UIImage imageNamed:@"day_filled.png"];
    self.tabBarItem.title = @"Plan";
}

- (void)configureCell:(NBClassCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NBClass *myClass = [self.currentFetchedResultsController objectAtIndexPath:indexPath];
    cell.classNameLabel.text = myClass.name;
    cell.lecturerNameLabel.text = [[[myClass lecturers] allObjects] componentsJoinedByString:@", "];
    NSDateComponents *start = [NBSchedule timeForPeriod:[myClass.start intValue]];
    NSDateComponents *end = [NBSchedule timeForPeriod:[myClass endOfClass]];
    cell.classTime.text = [NSString stringWithFormat:@"%02d:%02d - %02d:%02d", start.hour, start.minute, end.hour, end.minute];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.classTypeIndicatorColor = [NBSchedule colorForTypeOfClass:myClass];
    cell.classTypeText = [myClass.type stringByPaddingToLength:1 withString:myClass.type startingAtIndex:0];
}

#define X_MARGIN 200
#define Y_MARGIN 100
#define TEXT_LABEL_WIDTH 200
- (void)setupEmptyTableViewLabel
{
    UIView *backgroundView = self.tableView.backgroundView;
    int posX = (self.view.frame.size.width - X_MARGIN) / 2;
    int posY = (self.view.frame.size.height / 2) - Y_MARGIN;
    
    self.emptyTableViewTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, TEXT_LABEL_WIDTH, 0)];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NBClassDetailTableViewController *detailViewController = [segue destinationViewController];
    NBClass *selectedClass = [self.currentFetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:sender]];
    detailViewController.currentClass = selectedClass;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

#pragma mark Gestures

- (void)setupGestures
{
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    gestureRecognizer.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)longPressRecognized:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        self.selectedIndexPath = indexPath;
        
        if (indexPath) {
            NBClass *selectedClass = [self.currentFetchedResultsController objectAtIndexPath:self.selectedIndexPath];
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

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NBClass *selectedClass = [self.currentFetchedResultsController objectAtIndexPath:self.selectedIndexPath];
        NBCourse *courseToDelete = selectedClass.course;
        [self.managedObjectContext deleteObject:courseToDelete];
    }
    else if (buttonIndex == 1)
    {
        NBClass *classToDelete = [self.currentFetchedResultsController objectAtIndexPath:self.selectedIndexPath];
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

#pragma mark Segmented Control

- (IBAction)viewSegmentedControlSwitchedSegment:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.currentFetchedResultsController = self.dayFetchedResultsController;
            break;
        case 1:
            self.currentFetchedResultsController = self.weekFetchedResultsController;
    }
    
    NSError *error = nil;
	if (![self.currentFetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    [self.tableView reloadData];
}

#pragma mark - Gestures

- (IBAction)leftSwipe:(id)sender
{
    if (self.viewSegmentedControl.selectedSegmentIndex == 0) {
        self.viewSegmentedControl.selectedSegmentIndex = 1;
        [self viewSegmentedControlSwitchedSegment:self.viewSegmentedControl];
    }
    
}

- (IBAction)rightSwipe:(id)sender
{
    if (self.viewSegmentedControl.selectedSegmentIndex == 1) {
        self.viewSegmentedControl.selectedSegmentIndex = 0;
        [self viewSegmentedControlSwitchedSegment:self.viewSegmentedControl];
    }
}

@end
