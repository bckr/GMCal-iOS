//
//  NBAppSettingsModifyScheduleTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 2/13/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBAppSettingsModifyScheduleTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
