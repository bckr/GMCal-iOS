//
//  AppointmentDetailTableViewController.h
//  GM Calendar
//
//  Created by Nils Becker on 1/19/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBClass.h"
#import "NBIndicatorView.h"

@interface NBClassDetailTableViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) NBClass *currentClass;

@end
