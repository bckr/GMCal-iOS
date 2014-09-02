//
//  NBCourseCell.m
//  GM Calendar
//
//  Created by Nils Becker on 3/4/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBCourseCompactCell.h"

@implementation NBCourseCompactCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _courseTypeIndicator = [[NBIndicatorView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_courseTypeIndicator];
        
        _courseNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_courseNameLabel];
        
        _courseLecturers = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_courseLecturers];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = CGRectMake(10, 30, 10, 10);
//    _courseTypeIndicator.alpha = 0.5;
    _courseTypeIndicator.color = _courseTypeIndicatorColor;
    [_courseTypeIndicator setFrame:frame];
    
    int maxWidth = self.editing ? 220 : 250;
    maxWidth -= self.showingDeleteConfirmation ? 30 : 0;
    
    CGRect innerFrame = CGRectMake(30, 15, maxWidth, 20);
    [_courseNameLabel setFrame:innerFrame];
    UIFont *myFont = [UIFont systemFontOfSize:17.0];
    [_courseNameLabel setFont:myFont];
    [_courseNameLabel setBackgroundColor:[UIColor clearColor]];
    
    innerFrame = CGRectMake(30, 35, maxWidth, 20);
    [_courseLecturers setFrame:innerFrame];
    [_courseLecturers setBackgroundColor:[UIColor clearColor]];
    [_courseLecturers setTextColor:[UIColor grayColor]];
    [_courseLecturers setFont:myFont];
}

@end
