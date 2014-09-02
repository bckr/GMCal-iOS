//
//  ClassDetailHeaderCell.m
//  GM Calendar
//
//  Created by Nils Becker on 1/22/13.
//  Copyright (c) 2013 Nils Becker. All rights reserved.
//

#import "NBClassDetailHeaderCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NBClassDetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _lectureTypeIndicator = [[UIView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_lectureTypeIndicator];
        
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:_classNameLabel];
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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = CGRectMake(10, 17, 10, 10);
//    _lectureTypeIndicator.alpha = 0.5;
    _lectureTypeIndicator.layer.cornerRadius = 5;
    [_lectureTypeIndicator setFrame:frame];
    
    CGRect innerFrame = CGRectMake(30, 0, 250, 44);
    [_classNameLabel setFrame:innerFrame];
    UIFont *myFont = [UIFont boldSystemFontOfSize:20.0];
    [_classNameLabel setFont:myFont];
    [_classNameLabel setBackgroundColor:[UIColor clearColor]];
    
    self.backgroundView = nil;
}

@end
