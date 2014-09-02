//
//  NBLecturerDetailViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/11/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBLecturerDetailViewController.h"
#import "NBActivityIndicatorCell.h"
#import "NBClassCompactCell.h"
#import "NBClass.h"
#import "NBClass+Management.h"
#import "NBLesson.h"
#import "NBSchedule.h"
#import "NBLecturer+Management.h"
#import "AppDelegate.h"

@interface NBLecturerDetailViewController ()

@end

@implementation NBLecturerDetailViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Dozent";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UIApplicationDidBecomeActiveNotification" object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    }];
    if (!self.currentLecturer.form) {
        [self fetchLecturerDetails];
    } else {
        self.hasFetchedLecturerDetails = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (NSArray *)currentLecturersClasses {
    NSMutableSet *classes = [[NSMutableSet alloc] initWithCapacity:3];
    
    for (NBLesson *lesson in [self.currentLecturer.lessons allObjects]) {
        if (lesson.classForLesson) {
            [classes addObject:lesson.classForLesson];
        }
    }
    
    return [classes allObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hasFetchedLecturerDetails ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.hasFetchedLecturerDetails) {
        return 1;
    } else {
        return section == 0 ? self.currentLecturer.contactInfo.count : self.currentLecturersClasses.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 44 : 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *lecturerDetailCellIdentifier = @"lecturerDetailCell";
    static NSString *compactClassCellIdentifier = @"compactClassCell";
    UITableViewCell *cell;
    
    if (self.hasFetchedLecturerDetails && indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:lecturerDetailCellIdentifier];
        cell.textLabel.text = [[[self.currentLecturer.contactInfo objectAtIndex:indexPath.row] allKeys] lastObject];
        cell.detailTextLabel.text = [[self.currentLecturer.contactInfo objectAtIndex:indexPath.row] valueForKey:cell.textLabel.text];
    } else if (self.hasFetchedLecturerDetails && indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:compactClassCellIdentifier];
        
        NBClass *myClass = [self.currentLecturersClasses objectAtIndex:indexPath.row];
        ((NBClassCompactCell *)cell).classNameLabel.text = myClass.name;
        NSDateComponents *start = [NBSchedule timeForPeriod:[myClass.start intValue]];
        NSDateComponents *end = [NBSchedule timeForPeriod:[myClass endOfClass]];
        NSString *day = [NBSchedule dayForPeriod:[myClass.day intValue]];
        ((NBClassCompactCell *)cell).classTime.text = [NSString stringWithFormat:@"%@s: %02d:%02d - %02d:%02d", day, start.hour, start.minute, end.hour, end.minute];

       ((NBClassCompactCell *)cell).classTypeIndicatorColor = [NBSchedule colorForTypeOfClass:myClass];

    } else if (!self.hasFetchedLecturerDetails) {
        cell = [NBActivityIndicatorCell new];
        [((NBActivityIndicatorCell *)cell).activityIndicatorView setHidesWhenStopped:YES];
        [((NBActivityIndicatorCell *)cell).activityIndicatorView startAnimating];
    }
    
    if (![@[@"Mail", @"Web", @"Tel"] containsObject:cell.textLabel.text]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (section == 0) {
        title = [NSString stringWithFormat:@"%@ %@", self.currentLecturer.forename, self.currentLecturer.surname];
    } else {
        title = @"Fächer";
    }
    return title;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
//    
//    if (sectionTitle == nil) {
//        return nil;
//    }
//    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(20, 8, 320, 20);
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor whiteColor];
//    label.shadowColor = [UIColor grayColor];
//    label.shadowOffset = CGSizeMake(1.0, 1.0);
//    label.font = [UIFont boldSystemFontOfSize:16];
//    label.text = sectionTitle;
//    
//    UIView *view = [[UIView alloc] init];
//    [view addSubview:label];
//    
//    return view;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *selectedCellString = [[[self.currentLecturer.contactInfo objectAtIndex:indexPath.row] allKeys] lastObject];
        if ([selectedCellString isEqualToString:@"Web"]) {
            NSString *homepage = self.currentLecturer.homepage;
            NSURL *url;
            if ([homepage hasPrefix:@"http://"] || [homepage hasPrefix:@"https://"]) {
                url = [NSURL URLWithString:homepage];
            } else {
                url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://", homepage]];
            }
            [[UIApplication sharedApplication] openURL:url];
        } else if ([selectedCellString isEqualToString:@"Mail"]) {
            NSString *mail = self.currentLecturer.email;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"mailto://", mail]];
            [[UIApplication sharedApplication] openURL:url];
        } else if ([selectedCellString isEqualToString:@"Tel"]) {
            NSString *phone = self.currentLecturer.phone;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"tel://", phone]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark URL Connection delegate

- (void)fetchLecturerDetails{
    
    NSLog(@"Started fetching Lecturer Details");
    
    NSString *lecturerAbbreviation = [self.currentLecturer.abbreviation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#warning api currently not working!
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://nils-becker.com/calendar/Lecturer/%@", lecturerAbbreviation]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:requestURL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.responseData = [[NSMutableData alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [connection start];
}

#pragma mark URLConnectionDownload delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"finished loading!");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error;
    NSDictionary *jsonRep = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    
    self.currentLecturer.form = NULL_TO_NIL([jsonRep valueForKey:@"anrede"]);
    self.currentLecturer.email = NULL_TO_NIL([jsonRep valueForKey:@"email"]);
    self.currentLecturer.homepage = NULL_TO_NIL([jsonRep valueForKey:@"homepage"]);
    self.currentLecturer.function = NULL_TO_NIL([jsonRep valueForKey:@"funktion"]);
    self.currentLecturer.room = NULL_TO_NIL([jsonRep valueForKey:@"raum_kz"]);
    self.currentLecturer.phone = NULL_TO_NIL([jsonRep valueForKey:@"tel_intern"]);
    self.currentLecturer.title = NULL_TO_NIL([jsonRep valueForKey:@"titel"]);
    
    self.hasFetchedLecturerDetails = YES;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:5];

    for (int i = 0; i < self.currentLecturer.contactInfo.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection Failed with Error: %@", error.userInfo);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark Helper Methods

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

@end
