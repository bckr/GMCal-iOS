//
//  NBClassCompactCell.h
//  GM Calendar
//
//  Created by Nils Becker on 2/11/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBIndicatorView.h"

@interface NBClassCompactCell : UITableViewCell

@property (nonatomic, readwrite) UILabel *classNameLabel;
@property (nonatomic, readwrite) UILabel *classTime;
@property (nonatomic, readwrite) NBIndicatorView *classTypeIndicator;
@property (nonatomic, readwrite) UIColor *classTypeIndicatorColor;

@end
