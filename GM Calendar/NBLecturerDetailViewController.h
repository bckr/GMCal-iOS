//
//  NBLecturerDetailViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 2/11/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })

#import <UIKit/UIKit.h>
#import "NBLecturer.h"

@interface NBLecturerDetailViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NBLecturer *currentLecturer;
@property (strong, nonatomic) NSArray *currentLecturersClasses;

@property (strong, nonatomic) NSMutableData *responseData;
@property (assign) BOOL hasFetchedLecturerDetails;

@end
