//
//  NBAppSettingsModifyScheduleTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/13/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBAppSettingsModifyScheduleTableViewController.h"
#import "AppDelegate.h"
#import "NBClass.h"
#import "NBClass+Management.h"
#import "NBCourse.h"
#import "NBSchedule.h"
#import "NBLecturer+Management.h"
#import "NBLecturer.h"
#import "NBCourseCompactCell.h"
#import "UIColor+Hex.h"

@interface NBAppSettingsModifyScheduleTableViewController ()

- (IBAction)buttonPressed:(UIButton *)sender;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation NBAppSettingsModifyScheduleTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error: %@", [error localizedDescription]);
    }
}

- (void)buttonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"smesterListSegue" sender:self];
    [self setEditing:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger numberOfSections = [[self.fetchedResultsController sections] count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSUInteger numberOfRows = [sectionInfo numberOfObjects];
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.fetchedResultsController.fetchedObjects count]) {
        return @"Aktueller Stundenplan";
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (![self.fetchedResultsController.fetchedObjects count]) {
        return @"Keine Module vorhanden";
    }
    return nil;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NBCourse *courseToDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.managedObjectContext deleteObject:courseToDelete];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}

#pragma mark FetchedResultController Delegation

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(NBCourseCompactCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - Managed object context

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

#pragma mark - Helper methods

- (void)configureCell:(NBCourseCompactCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBCourse *currentCourse = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.courseNameLabel.text = currentCourse.name;
    NSMutableSet *lecturersOfClass = [[NSMutableSet alloc] init];
    
    for (NBClass *class in currentCourse.classes) {
        [lecturersOfClass addObjectsFromArray:[class.lecturers allObjects]];
    }
    
    NSSortDescriptor *sortNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    NSArray *allLecturers = [[lecturersOfClass allObjects] sortedArrayUsingDescriptors:@[sortNameDescriptor]];
    cell.courseLecturers.text = [allLecturers componentsJoinedByString:@", "];
    NBClass *lastClassOfCourse = [[currentCourse.classes allObjects] lastObject];
    UIColor *indicatorColor;
    
    if ([lastClassOfCourse.type isEqualToString:@"S"]) {
        indicatorColor = [UIColor colorWithHexString:@"a5de37"];
    } else {
        indicatorColor = [UIColor colorWithHexString:@"1b9af7"];
    }
    cell.courseTypeIndicatorColor = indicatorColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
