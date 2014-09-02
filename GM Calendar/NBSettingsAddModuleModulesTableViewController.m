//
//  NBAddModuleModulesTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/14/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBSettingsAddModuleModulesTableViewController.h"
#import "AppDelegate.h"
#import "NBCourse.h"
#import "NBClass+Management.h"
#import "NBClass.h"
#import "NBActivityIndicatorCell.h"
#import "NBCourseFetcher.h"
#import "NBCourseCompactCell.h"
#import "NBSchedule.h"
#import "UIColor+Hex.h"

@interface NBSettingsAddModuleModulesTableViewController ()

@property (nonatomic, strong) NBCourseFetcher *courseFetcher;
@property (nonatomic, strong) NSMutableArray *courses;
@property (nonatomic, strong) NSMutableSet *selectedCourses;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) BOOL didLoadCourses;

@end

@implementation NBSettingsAddModuleModulesTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!self.committedChanges) [[self.managedObjectContext undoManager] undo];
    self.courseFetcher = nil;
}

- (NSMutableSet *)selectedCourses {
    if(!_selectedCourses) _selectedCourses = [[NSMutableSet alloc] initWithCapacity:3];
    return _selectedCourses;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.didLoadCourses ? 70 : 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.didLoadCourses && ![self.courses count]) {
        return @"Keine Module vorhanden";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger coursesCount = [self.courses count];
    return self.didLoadCourses ? coursesCount : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    static NSString *ActivityCellIdentifier = @"activityIndicatorCell";
    static NSString *CourseCellIdentifier = @"selectCourseCell";
    
    if (!self.didLoadCourses) {
        cell = [tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CourseCellIdentifier];
        [self configureCell:(NBCourseCompactCell *)cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSMutableArray *)courses {
    if (!_courses) {
        _courses = [[NSMutableArray alloc] initWithCapacity:10];
        NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self.courseFetcher selector:@selector(fetchCourses) userInfo:nil repeats:NO];
    }
    return _courses;
}

- (NBCourseFetcher *)courseFetcher {
    if (!_courseFetcher) {
        NSString *major = [[NSUserDefaults standardUserDefaults] stringForKey:@"major"];
        NSString *branch = [[NSUserDefaults standardUserDefaults] stringForKey:@"branch"];
        NSLog(@"Semester: %d Branch: %@ Major: %@", self.semester, branch, major);
        _courseFetcher = [[NBCourseFetcher alloc] initWithMajor:major branch:branch semester:self.semester];
        _courseFetcher.delegate = self;
        _courseFetcher.managedObjectContext = self.managedObjectContext;
    }
    return _courseFetcher;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didLoadCourses) {
        if ([self.selectedCourses containsObject:[self.courses objectAtIndex:indexPath.row]]) {
            [self.selectedCourses removeObject:[self.courses objectAtIndex:indexPath.row]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [self.selectedCourses addObject:[self.courses objectAtIndex:indexPath.row]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        if ([self.selectedCourses count] > 0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectedItems)];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

#pragma mark Course fetcher delegate

- (void)courseFetcherDidLoadCourses:(NSArray *)courses forBranch:(NSString *)branch inSemester:(NSUInteger)semester {
    if ([courses count] > 0) {
        self.didLoadCourses = YES;
        self.courses = [courses mutableCopy];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSString *errorMessage;
       
        if (semester == [[NSUserDefaults standardUserDefaults] integerForKey:@"semester"]) {
            errorMessage = @"Es scheint so, als hättest du bereits alle Module dieses Semesters geladen";
        } else {
            errorMessage = @"Dieses Semester bietet wohl momentan keine Module an";
        }
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Keine Module gefunden" message:errorMessage delegate:self cancelButtonTitle:@"Zur Übersicht" otherButtonTitles:nil];
        [errorAlert show];
    }
}

#pragma mark Error handling

- (void)courseFetcherDidFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"💥💢🔥💨" message:@"Du musst mit dem Internet verbunden sein, um neue Module laden zu können" delegate:self cancelButtonTitle:@"Zur Übersicht" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Managed object context

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

#pragma mark - selection

-(void)selectedItems {
    self.committedChanges = YES;
    
    NSMutableSet *coursesToDelete = [[NSMutableSet alloc] initWithArray:self.courses];
    [coursesToDelete minusSet:self.selectedCourses];
    
    for (NBCourse *courseToDelete in coursesToDelete) {
        [self.managedObjectContext deleteObject:courseToDelete];
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error: %@", [error localizedDescription]);
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"modal view dismissed");
        }];
    }
    
}

#pragma mark - Helper methods

- (void)configureCell:(NBCourseCompactCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NBCourse *currentCourse = [self.courses objectAtIndex:indexPath.row];
    
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
    
    if ([self.selectedCourses containsObject:[self.courses objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
