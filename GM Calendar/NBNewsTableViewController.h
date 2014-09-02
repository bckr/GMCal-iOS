//
//  NBNewsTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 2/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBNewsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
