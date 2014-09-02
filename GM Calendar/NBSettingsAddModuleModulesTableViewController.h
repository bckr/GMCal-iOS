//
//  NBAddModuleModulesTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 2/14/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBCourseFetcher.h"

@interface NBSettingsAddModuleModulesTableViewController : UITableViewController <NBCourseFetcherDelegate, UIAlertViewDelegate>

@property int semester;
@property BOOL committedChanges;

@end
