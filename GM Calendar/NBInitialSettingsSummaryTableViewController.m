//
//  NBInitialSettingsSummaryTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsSummaryTableViewController.h"
#import "NBCourseFetcher.h"
#import "NBCourse.h"
#import "NBClass.h"
#import "AppDelegate.h"
#import "NBNewsItem.h"
#import "NBLesson.h"
#import "NBInitialSettingsCustomizeSeminarsTableViewController.h"
#import "NBInitialSettingsCustomizeCoursesTableViewController.h"

@interface NBInitialSettingsSummaryTableViewController ()

@property (readonly) NSUInteger seminarCount;
@property (readonly) NSUInteger courseCount;
@property (nonatomic, strong) NSSet *selectedSeminars;
@property (nonatomic, strong) NSSet *selectedCourses;
@property (nonatomic, strong) NSArray *courses;

@end

@implementation NBInitialSettingsSummaryTableViewController

- (void)viewDidLoad {
    // start fetching custom schedule
    NBCourseFetcher *fetcher = [[NBCourseFetcher alloc] initWithMajor:self.major branch:self.branch semester:self.semester];
    id appDelegate = (id)[[UIApplication sharedApplication] delegate];
    fetcher.managedObjectContext = [appDelegate managedObjectContext];
    fetcher.delegate = self;
    [fetcher fetchCourses];
    
    // start activity indicator
    [self.courseSpinner startAnimating];
    [self.seminarSpinner startAnimating];
    
    // disable cell selection
    self.seminarsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.seminarsCell.accessoryType = UITableViewCellAccessoryNone;
    self.coursesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coursesCell.accessoryType = UITableViewCellAccessoryNone;
    self.submitCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.submitCellLabel.textColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.majorLabel.text = self.major;
    self.branchLabel.text = [self.branchNames valueForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"branch"]];
    self.semesterLabel.text = [NSString stringWithFormat:@"%u. Semester", self.semester];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:2] animated:YES];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0 && ![self.courseSpinner isAnimating]) {
        if (![self.selectedCourses count] && ![self.selectedSeminars count]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Mit leerem Stundenplan starten?"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Abbrechen"
                                                       destructiveButtonTitle:@"Prokrastinieren"
                                                            otherButtonTitles:nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
        } else if (![self.selectedSeminars count] && [@[@"4", @"5"] containsObject:[NSString stringWithFormat:@"%u", self.semester]]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Kein Wahlpflichtfach ausgewählt!"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Abbrechen"
                                                       destructiveButtonTitle:@"Ohne WPF fortfahren"
                                                            otherButtonTitles:@"WPF auswählen", nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [actionSheet showInView:self.view];
        } else {
            [self performSegueWithIdentifier:@"settingsCompleted" sender:self];
        }
    } else if (indexPath.section == 1 && indexPath.row == 0 && ![self.courseSpinner isAnimating] && self.courseCount > 0) {
        [self performSegueWithIdentifier:@"customizeCoursesSegue" sender:self];
    } else if (indexPath.section == 1 && indexPath.row == 1 && ![self.seminarSpinner isAnimating] && self.seminarCount > 0) {
        [self performSegueWithIdentifier:@"customizeSeminarsSegue" sender:self];
    }
}

#pragma mark Action Sheet delegation

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:@"settingsCompleted" sender:self];
    } else if (buttonIndex == 1) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"WPF auswählen"]) {
            [self performSegueWithIdentifier:@"customizeSeminarsSegue" sender:self];
        }
    } else {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:3] animated:YES];
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"settingsCompleted"]) {
        // Setup fresh Schedule from selected Courses and flush all previous news entries
        [self setupSchedule];
        [self flushAllNewsEntries];
        
        // save the context
        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved Error saving Context: %@", [error localizedDescription]);
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([segue.identifier isEqualToString:@"customizeSeminarsSegue"]) {
        NBInitialSettingsCustomizeSeminarsTableViewController *nextView = segue.destinationViewController;
        nextView.delegate = self;
        
        // if segue was called before, set the currently selected seminars
        if (self.selectedSeminars) {
            nextView.selectedSeminars = [self.selectedSeminars mutableCopy];
        }
        nextView.seminars = [self seminars];
        
    }
    else if ([segue.identifier isEqualToString:@"customizeCoursesSegue"]) {
        NBInitialSettingsCustomizeCoursesTableViewController *nextView = segue.destinationViewController;
        nextView.delegate = self;
        
        // if segue was called before, set the currently selected seminars
        if (self.selectedCourses) {
            nextView.selectedCourses = [self.selectedCourses mutableCopy];
        }
        
        nextView.classes = [self classes];
    }
}

- (void)didSelectSeminars:(NSSet *)seminars {
    // updated selected seminars and its corresponding labels
    self.selectedSeminars = seminars;
    [self updateCountLabels];
}

- (void)didSelectCourses:(NSSet *)courses {
    self.selectedCourses = courses;
    [self updateCountLabels];
}

- (void)updateCountLabels {
    if (!self.selectedCourses) {
        NSMutableSet *filteredClasses = [[NSMutableSet alloc] init];
        for (NBCourse *course in self.courses) {
            NBClass *lastClass = [[course.classes allObjects] lastObject];
            if (![lastClass.type isEqualToString:@"S"])
                [filteredClasses unionSet:course.classes];
        }
        self.selectedCourses = filteredClasses;
    }
    self.courseCountLabel.text = [NSString stringWithFormat:@"%u/%u", [self.selectedCourses count], self.courseCount];
    self.seminarCountLabel.text = [NSString stringWithFormat:@"%u/%u", [self.selectedSeminars count], self.seminarCount];
}

#pragma mark Course Fetcher Delegate

- (void)courseFetcherDidLoadCourses:(NSArray *)courses forBranch:(NSString *)branch inSemester:(NSUInteger)semester {
    self.courses = courses;
    
    // update labels content
    [self updateCountLabels];
    
    // stop activity indicators and show labels
    [self.courseSpinner stopAnimating];
    [self.seminarSpinner stopAnimating];
    self.courseCountLabel.hidden = NO;
    self.seminarCountLabel.hidden = NO;
    
    // enable cell selection
    if (self.courseCount) {
        self.coursesCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.coursesCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.seminarCount) {
        self.seminarsCell.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.seminarsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.submitCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.submitCellLabel.textColor = [UIColor blackColor];
}

#pragma mark Error handling

- (void)courseFetcherDidFailWithError:(NSError *)error {
    // update labels content
    [self updateCountLabels];
    
    // stop activity indicators and show labels
    [self.courseSpinner stopAnimating];
    [self.seminarSpinner stopAnimating];
    self.courseCountLabel.hidden = NO;
    self.seminarCountLabel.hidden = NO;
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"💥💢🔥💨" message:@"Dein Stundenplan konnte nicht geladen werden! Bist du mit dem Internet verbunden?" delegate:self cancelButtonTitle:@"Zur Semesterübersicht" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Helper methods

#warning missing entries
- (NSDictionary *)branchNames
{
    return @{@"WI" : @"Wirtschaftsinformatik", @"MI" : @"Medieninformatik",  @"TI" : @"Technische Informatik", @"AI" : @"Allgemeine Informatik", @"MMF" : @"Maschinenbau Schwerpunkt Fertigung", @"EEL" : @"Elektronik", @"EAT" : @"Automatisierungstechnik", @"MW" : @"Wirtschaftsingenieurwesen", @"MM" : @"Maschinenbau", @"BB" : @"Ingenieurwissenschaftliches Grundstudium", @"II" : @"Informatik-Ingenieur", @"MWE" : @"Wirtschaftsingenieur Elektrotechnik", @"MWM" : @"Wirtschaftsingenieur Maschinenbau",  @"MMII" : @"Maschinenbau Informatik", @"MMK" : @"Maschinenbau Konstruktion", @"PPDM" : @"Master Produktdesign und Prozessentwicklung", @"AITM" : @"Automation and IT Master", @"MMI" : @"Medieninformatik-Master", @"IM" : @"Informatik-Master", @"WEB" : @"Web Science"};
}

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

- (NSString *)major {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"major"];
}

- (NSString *)branch {
    return  [[NSUserDefaults standardUserDefaults] stringForKey:@"branch"];
}

- (unsigned)semester {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"semester"];
}

- (NSUInteger)courseCount {
    return [[self classes] count];
}

- (NSUInteger)seminarCount {
    return [[self seminars] count];
}

- (NSArray *)seminars {
    NSMutableSet *filteredClasses = [[NSMutableSet alloc] init];
    for (NBCourse *course in self.courses) {
        NBClass *lastClass = [[course.classes allObjects] lastObject];
        if ([lastClass.type isEqualToString:@"S"])
            [filteredClasses unionSet:course.classes];
    }
    return [filteredClasses allObjects];
}

- (NSArray *)classes {
    NSMutableSet *filteredClasses = [[NSMutableSet alloc] init];
    for (NBCourse *course in self.courses) {
        NBClass *lastClass = [[course.classes allObjects] lastObject];
        if (![lastClass.type isEqualToString:@"S"])
            [filteredClasses unionSet:course.classes];
    }
    return [filteredClasses allObjects];
}

- (void)setupSchedule {
    // fetch all classes
    NSFetchRequest *classFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Class"];
    // get all deselected classes
    NSMutableSet *classesToDelete = [NSMutableSet setWithArray:[self.managedObjectContext executeFetchRequest:classFetchRequest error:nil]];
    
    for (NBCourse *course in self.courses) {
        [classesToDelete unionSet:course.classes];
    }
    
    // delete deselected seminars
    [classesToDelete minusSet:self.selectedSeminars];
    [classesToDelete minusSet:self.selectedCourses];
    for (NBClass *classToDelete in classesToDelete) {
        NBCourse *courseForSelectedClass = classToDelete.course;
        
        if ([courseForSelectedClass.classes count] > 1) {
            [self.managedObjectContext deleteObject:classToDelete];
            [self.managedObjectContext save:nil];
        } else {
            // delete the enire course if no classes are left
            NBCourse *courseToDelete = classToDelete.course;
            [self.managedObjectContext deleteObject:courseToDelete];
        }
    }
}

- (void)flushAllNewsEntries {
    NSFetchRequest *newsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
    NSArray *newsItems = [self.managedObjectContext executeFetchRequest:newsFetchRequest error:NULL];
    
    for (NBNewsItem *newsItem in newsItems) {
        [self.managedObjectContext deleteObject:newsItem];
    }
}

@end
