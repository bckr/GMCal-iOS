//
//  NBInitialSettingsCustomizeSeminarsTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 3/5/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol seminarSelectionDelegate <NSObject>

- (void)didSelectSeminars:(NSSet *)seminars;

@end

@interface NBInitialSettingsCustomizeSeminarsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<seminarSelectionDelegate> delegate;
@property (nonatomic, strong) NSMutableSet *selectedSeminars;
@property (nonatomic, strong) NSArray *seminars;

@end
