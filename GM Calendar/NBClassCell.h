//
//  ShowCellController.h
//  TV Tracker
//
//  Created by Nils Becker on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBIndicatorView.h"

@interface NBClassCell : UITableViewCell

@property (nonatomic, readwrite) UILabel *classNameLabel;
@property (nonatomic, readwrite) UILabel *lecturerNameLabel;
@property (nonatomic, readwrite) UILabel *classTime;
@property (nonatomic, readwrite) NBIndicatorView *classTypeIndicator;
@property (nonatomic, readwrite) UIColor *classTypeIndicatorColor;
@property (nonatomic, readwrite) NSString *classTypeText;

@end
