//
//  NBNewsItemCell.h
//  GM Calendar
//
//  Created by Nils Becker on 2/27/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBIndicatorView.h"

@interface NBNewsItemCell : UITableViewCell

@property (nonatomic, readwrite) UILabel *author;
@property (nonatomic, readwrite) UILabel *date;
@property (nonatomic, readwrite) UILabel *newsTitle;
@property (nonatomic, readwrite) UILabel *newsType;
@property (nonatomic, readwrite) UILabel *newsMeta;
@property (nonatomic, readwrite) NBIndicatorView *readIndicator;
@property (nonatomic, readwrite) BOOL read;

@end
