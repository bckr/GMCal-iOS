//
//  ShowCellController.m
//  TV Tracker
//
//  Created by Nils Becker on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NBClassCell.h"
#import "NBIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NBClassCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
    if (self) {
        _classTypeIndicator = [[NBIndicatorView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classTypeIndicator];
        
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classNameLabel];
        
        _lecturerNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_lecturerNameLabel];
        
        _classTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classTime];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIColor *classNameTextColor;
    UIColor *detailTextColor;
    
    _classTypeIndicator.text = self.classTypeText;
    
//    if (self.selected || self.highlighted) {
//        classNameTextColor = [UIColor whiteColor];
//        detailTextColor = [UIColor whiteColor];
//        _classTypeIndicator.alpha = 1.0;
//        _classTypeIndicator.color = [UIColor whiteColor];
//        _classTypeIndicator.textLayer.foregroundColor = [UIColor blackColor].CGColor;
//    } else {
        classNameTextColor = [UIColor blackColor];
        detailTextColor = [UIColor grayColor];
        _classTypeIndicator.color = _classTypeIndicatorColor;
//    }
    
    CGRect frame = CGRectMake(10, 35, 20, 20);
    [_classTypeIndicator setFrame:frame];

    CGRect innerFrame = CGRectMake(40, 15, 240, 20);
    [_classNameLabel setFrame:innerFrame];

    UIFont *myFont = [UIFont systemFontOfSize:17.0];
    [_classNameLabel setFont:myFont];
    [_classNameLabel setTextColor:classNameTextColor];
    [_classNameLabel setBackgroundColor:[UIColor clearColor]];
    
    innerFrame = CGRectMake(40, 35, 230, 20);
    [_lecturerNameLabel setFrame:innerFrame];
    [_lecturerNameLabel setBackgroundColor:[UIColor clearColor]];
    [_lecturerNameLabel setTextColor:detailTextColor];
    [_lecturerNameLabel setFont:myFont];
    
    innerFrame = CGRectMake(40, 55, 230, 20);
    [_classTime setFrame:innerFrame];
    [_classTime setBackgroundColor:[UIColor clearColor]];
    [_classTime setTextColor:detailTextColor];
    [_classTime setFont:myFont];
}

@end
