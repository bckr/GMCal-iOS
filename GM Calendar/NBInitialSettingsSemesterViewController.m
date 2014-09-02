//
//  NBInitialSettingsSemesterViewController.m
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBInitialSettingsSemesterViewController.h"
#import "NBInitialSettingsSummaryTableViewController.h"
#import "AppDelegate.h"
#import "NBCourse.h"

@interface NBInitialSettingsSemesterViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation NBInitialSettingsSemesterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    // if the view appears a second time, delete current courses
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"semester"] != 0)
    {
//        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Course"];
//        NSArray *coursesToDelete = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];

        NSSet *coursesToDelete = [self.managedObjectContext insertedObjects];
        
        for (NBCourse *course in coursesToDelete) {
            [self.managedObjectContext deleteObject:course];
        }

        NSError *error;
        if(![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved Error saving Context: %@", [error localizedDescription]);
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SemesterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%u. Semester", (indexPath.row + 1)];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    unsigned semester = indexPath.row + 1;
    NSLog(@"Selected semester: %d", semester);
    [[NSUserDefaults standardUserDefaults] setInteger:semester forKey:@"semester"];
    [self performSegueWithIdentifier:@"summarySegue" sender:self];
}

@end
