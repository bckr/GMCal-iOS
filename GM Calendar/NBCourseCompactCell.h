//
//  NBCourseCell.h
//  GM Calendar
//
//  Created by Nils Becker on 3/4/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBIndicatorView.h"

@interface NBCourseCompactCell : UITableViewCell

@property (nonatomic, readwrite) UILabel *courseNameLabel;
@property (nonatomic, readwrite) UILabel *courseLecturers;
@property (nonatomic, readwrite) NBIndicatorView *courseTypeIndicator;
@property (nonatomic, readwrite) UIColor *courseTypeIndicatorColor;

@end
