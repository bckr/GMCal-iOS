//
//  NBClassCompactCell.m
//  GM Calendar
//
//  Created by Nils Becker on 2/11/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBClassCompactCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NBClassCompactCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _classTypeIndicator = [[NBIndicatorView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classTypeIndicator];
        
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classNameLabel];
        
        _classTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classTime];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(10, 30, 10, 10);
//    _classTypeIndicator.alpha = 0.5;
    _classTypeIndicator.color = _classTypeIndicatorColor;
    [_classTypeIndicator setFrame:frame];
    
    CGRect innerFrame = CGRectMake(30, 15, 250, 20);
    [_classNameLabel setFrame:innerFrame];
    UIFont *myFont = [UIFont systemFontOfSize:17.0];
    [_classNameLabel setFont:myFont];
    [_classNameLabel setBackgroundColor:[UIColor clearColor]];
    
    innerFrame = CGRectMake(30, 35, 250, 20);
    [_classTime setFrame:innerFrame];
    [_classTime setBackgroundColor:[UIColor clearColor]];
    [_classTime setTextColor:[UIColor grayColor]];
    [_classTime setFont:myFont];
}

@end
