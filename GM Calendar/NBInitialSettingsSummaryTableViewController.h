//
//  NBInitialSettingsSummaryTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 2/10/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCourseFetcher.h"
#import "NBInitialSettingsCustomizeSeminarsTableViewController.h"
#import "NBInitialSettingsCustomizeCoursesTableViewController.h"

@interface NBInitialSettingsSummaryTableViewController : UITableViewController <NBCourseFetcherDelegate, seminarSelectionDelegate, courseSelectionDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *semesterLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *courseSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *seminarSpinner;
@property (weak, nonatomic) IBOutlet UILabel *courseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seminarCountLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *coursesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *seminarsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *submitCell;
@property (weak, nonatomic) IBOutlet UILabel *submitCellLabel;

@property (strong, nonatomic) NSString *major;
@property (strong, nonatomic) NSString *branch;
@property (nonatomic) unsigned semester;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
