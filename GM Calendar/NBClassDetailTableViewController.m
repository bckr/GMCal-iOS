//
//  AppointmentDetailTableViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 1/19/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBClassDetailTableViewController.h"
#import "NBClassDetailHeaderCell.h"
#import "NBLesson.h"
#import "NBClass+Management.h"
#import "NBSchedule.h"
#import "NBLecturer.h"
#import "NBLecturerDetailViewController.h"
#import "AppDelegate.h"
#import "NBClassCompactCell.h"
#import "NBCourse.h"

@interface NBClassDetailTableViewController ()

@end

@implementation NBClassDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.navigationController.navigationBar.tintColor = [NBSchedule colorForTypeOfClass:self.currentClass];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

#pragma mark Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:3];
    if (editing) {
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//        if ([self.currentClass.lecturers count] > 1 || [[UIScreen mainScreen] bounds].size.height < 568) {
            NSIndexPath *indexPathOfLastCell = [NSIndexPath indexPathForItem:0 inSection:3];
            [self.tableView scrollToRowAtIndexPath:indexPathOfLastCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
    } else {
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//        if ([self.currentClass.lecturers count] > 1 || [[UIScreen mainScreen] bounds].size.height < 568) {
            NSIndexPath *indexPathOfFirstCell = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPathOfFirstCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 70 : 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isEditing ? 4 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 3:
            return 1;
        case 1:
            return 3;
        case 2:
            return [self.currentClass.lecturers count];
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *classCellIdentifier = @"classCell";
    static NSString *classDetailCellIdentifier = @"classDetailCell";
    static NSString *lecturerCellIdentifier = @"lecturerCell";
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:classCellIdentifier];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:classDetailCellIdentifier];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:lecturerCellIdentifier];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:classDetailCellIdentifier];
            break;
    }
    
    NBLesson *lesson = [self.currentClass.sortedLessons objectAtIndex:0];
    
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    numberFormat.usesGroupingSeparator = YES;
    numberFormat.groupingSeparator = @".";
    numberFormat.groupingSize = 3;
    
    NSDateComponents *start = [NBSchedule timeForPeriod:[self.currentClass.start intValue]];
    NSDateComponents *end = [NBSchedule timeForPeriod:[self.currentClass endOfClass]];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ((NBClassCompactCell *)cell).classNameLabel.text = self.currentClass.name;
        NSDateComponents *start = [NBSchedule timeForPeriod:[self.currentClass.start intValue]];
        NSDateComponents *end = [NBSchedule timeForPeriod:[self.currentClass endOfClass]];
        NSString *day = [NBSchedule dayForPeriod:[self.currentClass.day intValue]];
        ((NBClassCompactCell *)cell).classTime.text = [NSString stringWithFormat:@"%@: %02ld:%02ld - %02ld:%02ld", day, (long)start.hour, (long)start.minute, (long)end.hour, (long)end.minute];
        ((NBClassCompactCell *)cell).classTypeIndicatorColor = [NBSchedule colorForTypeOfClass:self.currentClass];
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Typ";
                cell.detailTextLabel.text = self.currentClass.typeString;
                break;
            case 1:
                cell.textLabel.text = @"Zeit";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%02ld:%02ld - %02ld:%02ld", (long)start.hour, (long)start.minute, (long)end.hour, (long)end.minute];;
                break;
            case 2:
                cell.textLabel.text = @"Raum";
                cell.detailTextLabel.text = [numberFormat stringFromNumber:lesson.room];
                break;
        }
    } else if (indexPath.section == 2) {
        NBLecturer *currentLecturer = [[self.currentClass.lecturers allObjects] objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentLecturer.forename, currentLecturer.surname];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    } else if (indexPath.section == 3) {
        UIButton *deleteClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteClassButton setFrame:[cell.contentView frame]];
        [deleteClassButton setFrame:CGRectMake(10, 0, cell.bounds.size.width-20, 44)];
        [deleteClassButton setBackgroundImage:[UIImage imageNamed:@"red_button_texture.png"] forState:UIControlStateNormal];
        [deleteClassButton setTitle:[NSString stringWithFormat:@"%@ entfernen", self.currentClass.typeString] forState:UIControlStateNormal];
        [deleteClassButton addTarget:self action:@selector(showDeleteActionSheet:) forControlEvents:UIControlEventTouchUpInside];
        deleteClassButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [cell addSubview:deleteClassButton];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Modul";
        case 1:
            return @"Übersicht";
        case 2:
            return [self.currentClass.lecturers count] > 1 ? @"Dozenten" : @"Dozent";
        default:
            return nil;
    }
}

#pragma mark Delete Class

- (void)showDeleteActionSheet:(id)sender {
    NSString *sheetTitle = [NSString stringWithFormat:@"%@ %@ entfernen?", self.currentClass.typeString, self.currentClass.name];
    NSString *buttonTitle = [NSString stringWithFormat:@"%@ entfernen", self.currentClass.typeString];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:sheetTitle
                                                             delegate:self
                                                    cancelButtonTitle:@"Abbrechen"
                                               destructiveButtonTitle:buttonTitle
                                                    otherButtonTitles:nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

#pragma mark Action Sheet delegation

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NBCourse *courseForSelectedClass = self.currentClass.course;
        
        if ([courseForSelectedClass.classes count] > 1) {
            [self.managedObjectContext deleteObject:self.currentClass];
        } else {
            // delete the enire course if no classes are left
            [self.managedObjectContext deleteObject:courseForSelectedClass];
        }
        
        [self.managedObjectContext deleteObject:self.currentClass];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NBLecturerDetailViewController *nextView = [segue destinationViewController];
    NBLecturer *currentLecturer = [[self.currentClass.lecturers allObjects] objectAtIndex:[self.tableView indexPathForCell:sender].row];
    nextView.currentLecturer = currentLecturer;
}

#pragma mark Helper methods

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

@end
