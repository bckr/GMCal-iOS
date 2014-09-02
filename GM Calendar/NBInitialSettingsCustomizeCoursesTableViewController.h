//
//  NBInitialSettingsCustomizeCoursesTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 3/5/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol courseSelectionDelegate <NSObject>

- (void)didSelectCourses:(NSSet *)courses;

@end

@interface NBInitialSettingsCustomizeCoursesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<courseSelectionDelegate> delegate;
@property (nonatomic, strong) NSMutableSet *selectedCourses;
@property (nonatomic, strong) NSArray *classes;

@end
